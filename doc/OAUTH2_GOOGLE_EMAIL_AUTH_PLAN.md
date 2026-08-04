# OAuth2 Google and Email Auth Plan

Status: proposed plan

Date: 2026-08-04

## Summary

Use `oauth2_client` only if we implement a generic OAuth2 browser redirect flow in the Flutter app. Between `oauth2_client` and `oauth2`, `oauth2_client` fits this mobile app better because it is Flutter-oriented and already handles browser redirect flow, callback activity setup, secure token storage, and predefined Google OAuth2 client helpers.

Do not use the backend email endpoint as OAuth2 sign-in. Current backend schema shows `POST /api/v1/accounts/auth/email/` as an authenticated endpoint that accepts and returns only an email value. It has `jwtAuth` security, so it is more likely for adding or updating an email on an existing account, not for initial login.

Do not implement Google sign-in against `POST /api/v1/accounts/auth/google/` yet as a production flow. Current backend schema exposes no request body and no response body for that endpoint, and it also marks the endpoint with `jwtAuth`. That contract is not enough to know whether the backend expects an authorization code, access token, ID token, Firebase token, or something else.

## Sources Checked

- `https://pub.dev/packages/oauth2_client`
- `https://pub.dev/packages/oauth2`
- `https://backend.raqamlisovchi.uz/api/schema/`
- Swagger UI paths:
  - `POST /api/v1/accounts/auth/google/`
  - `POST /api/v1/accounts/auth/email/`

## Package Decision

### Recommended if choosing between the two: `oauth2_client`

Reasons:

- It is a Flutter package, not only a Dart package.
- It supports Authorization Code flow and provides predefined Google client helpers.
- It uses browser-based redirect flow through Flutter platform integration.
- It is closer to what a mobile app needs: open browser, receive callback, extract OAuth result.
- It can work without us hand-rolling the redirect listener.

Important constraint:

- Do not use `oauth2_client` as the app's main API client.
- Do not let it own Raqamli Sovchi backend JWT lifecycle.
- Use it only to get the external Google OAuth result, then exchange that result with the backend.
- Backend access/refresh tokens must still be stored only through the existing `TokenStore`.

### Not recommended as primary Flutter auth package: `oauth2`

Reasons:

- It is a lower-level Dart OAuth2 package.
- It can model Authorization Code, credentials, refresh, and HTTP client behavior, but it does not provide a complete Flutter redirect integration.
- For Flutter apps, redirect handling still needs extra pieces such as `url_launcher` plus an app/deep link listener, or a WebView.
- This project already has strict auth flow, router, token store, and Dio integration. Adding a low-level OAuth client would require more custom platform code and more test surface.

Use `oauth2` only if we intentionally want to own the full OAuth2 state machine and callback/deep-link handling ourselves. That is not necessary for the current app.

## Backend Contract Findings

### Google endpoint

Schema:

```text
POST /api/v1/accounts/auth/google/
operationId: v1_accounts_auth_google_create
security: jwtAuth
200: No response body
```

Current blocker:

- No request schema.
- No response schema.
- No examples.
- Security says `jwtAuth`, which conflicts with it being an unauthenticated sign-in endpoint.

Required backend clarification:

- Is this endpoint for initial login/register or for linking Google to an already authenticated account?
- Should mobile send `id_token`, `access_token`, `authorization_code`, or another provider credential?
- Is PKCE required?
- What exact success response returns backend access and refresh tokens?
- Does the response use the same token shape as `/api/v1/accounts/auth/token/`?
- What are validation/error responses for cancelled, invalid token, unverified email, blocked user, and already linked account?
- Should mobile use Google OAuth client IDs for Android/iOS, or does backend provide a custom OAuth start URL?

Until those are answered, production Google auth should stay disabled or show a clear unavailable state.

### Email endpoint

Schema:

```text
POST /api/v1/accounts/auth/email/
security: jwtAuth
request: EmailAuthRequest { email: string, format: email, minLength: 1 }
response: EmailAuth { email: string, format: email }
```

Interpretation:

- This is not OAuth2.
- This is not a complete email login flow.
- Because it requires `jwtAuth`, it appears to be an authenticated account email attach/update endpoint.

Required backend clarification:

- Is email supposed to be login, registration, profile update, or account linking?
- If email login is planned, where are the password, OTP, magic link, verification code, or token exchange endpoints?
- Should unauthenticated users call this endpoint? If yes, `jwtAuth` in schema is wrong.

## Proposed Google Flow After Backend Contract Is Fixed

Target architecture:

```text
LoginPage
  -> AuthGoogleSignInRequested
  -> AuthBloc
  -> SignInWithGoogleUseCase
  -> AuthRepository
  -> GoogleOAuthDataSource
  -> oauth2_client opens Google OAuth
  -> receive provider result
  -> RemoteAuthDataSource POST /api/v1/accounts/auth/google/
  -> backend returns app access/refresh tokens
  -> TokenStore.saveTokens
  -> AuthBloc emits PIN gate
```

Implementation rules:

- Domain layer must not import `oauth2_client`.
- `oauth2_client` belongs in data or core platform integration only.
- BLoC calls a use case only.
- Repository returns `Either<Failure, Session>`.
- Raw provider exceptions map to typed `Failure`.
- Backend JWT tokens remain the only tokens used by Dio interceptors.
- Google OAuth token/code must not be logged.

## Data Layer Shape

Add a provider abstraction:

```dart
abstract interface class GoogleOAuthProvider {
  Future<GoogleOAuthCredential> signIn();
}
```

Model the external credential separately:

```dart
final class GoogleOAuthCredential {
  const GoogleOAuthCredential({
    this.authorizationCode,
    this.idToken,
    this.accessToken,
  });

  final String? authorizationCode;
  final String? idToken;
  final String? accessToken;
}
```

The request DTO must wait for backend confirmation. Possible shapes:

```json
{ "id_token": "<google id token>" }
```

or:

```json
{ "code": "<authorization code>", "redirect_uri": "<redirect uri>" }
```

Do not guess which one is correct.

## Package Integration Plan

If backend confirms mobile should perform OAuth:

1. Add `oauth2_client` only after confirming Android/iOS callback requirements.
2. Configure Android callback activity for the app redirect scheme.
3. Configure iOS URL scheme.
4. Add non-secret OAuth config to app config:
   - Google Android client ID
   - Google iOS client ID
   - Redirect URI/custom scheme
   - Scopes
5. Implement `GoogleOAuthProvider` behind data/core platform boundary.
6. Update `RemoteAuthDataSource.signInWithGoogle`.
7. Map backend token response to `AuthSessionModel`.
8. Store backend tokens via `TokenStore`.
9. Route successful login into existing PIN setup/unlock flow.
10. Add tests for provider cancellation, backend validation failure, token save, and BLoC state transitions.

## Email Auth Plan

Do not build email login from current endpoint.

Use current email endpoint only if product wants "add email to current account" after login. That should be implemented as a profile/account setting, not as `AuthGoogleSignInRequested` or initial auth.

If backend later adds email login, required contract:

- Start email auth request.
- Verify OTP/magic link/password.
- Return backend access/refresh tokens.
- Define resend, expiry, rate-limit, and error response rules.

## Acceptance Criteria Before Implementation

- Backend provides concrete Google request and response examples.
- Backend clarifies whether Google endpoint is unauthenticated login or authenticated account linking.
- Backend provides token response shape.
- Backend confirms whether mobile should send authorization code, ID token, or access token.
- App callback scheme is registered for Android and iOS.
- No OAuth client secret is shipped in the mobile app.
- Tests cover provider cancellation, invalid provider credential, backend failure, and successful session-to-PIN gate.

## Final Recommendation

Use `oauth2_client` if we must choose from the two packages, but do not implement Google login until backend fixes or clarifies `POST /api/v1/accounts/auth/google/`.

Do not use `POST /api/v1/accounts/auth/email/` for OAuth2 or login. It is currently an authenticated email attach/update style endpoint, not an auth flow.
