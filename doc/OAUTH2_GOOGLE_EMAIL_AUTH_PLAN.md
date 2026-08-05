# Google Sign-In server auth code plan

Status: implementation updated

Date: 2026-08-05

## Decision

Use `google_sign_in`, not `oauth2_client`, for Google login in the mobile app.

Reason: Google blocks custom-scheme OAuth authorization requests on Android in
modern OAuth policy enforcement. The app should use the native Google Sign-In
SDK flow and request a server auth code.

## Target flow

```text
LoginPage
  -> GoogleSignIn.authenticate()
  -> account.authorizationClient.authorizeServer(scopes)
  -> serverAuthCode
  -> POST /api/v1/accounts/auth/google/
  -> backend exchanges code with Google
  -> backend returns Raqamli Sovchi access/refresh tokens
  -> TokenStore saves backend tokens in secure storage
  -> existing PIN setup/unlock gate
  -> Home
```

## Backend request

Endpoint:

```text
POST https://backend.raqamlisovchi.uz/api/v1/accounts/auth/google/
```

Request body:

```json
{
  "authorization_code": "<google-server-auth-code>"
}
```

The request must use `skipAuth: true` so an expired Raqamli Sovchi JWT is not
attached to a public auth endpoint.

Do not send:

- Raqamli Sovchi access token as Google `access_token`;
- custom mobile `redirect_uri`;
- Google client secret from the app.

## Google Cloud setup

Android requires two OAuth clients:

- Android OAuth client: configured with package name and SHA-1 fingerprint.
  This identifies the installed Android app.
- Web application OAuth client: passed to Flutter as
  `GOOGLE_SERVER_CLIENT_ID` and configured on the backend for code exchange.

The Web application client ID is public enough to be passed to the mobile app.
The Web application client secret must stay only on the backend.

## Flutter config

The app reads:

```dart
String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID')
```

Build example:

```powershell
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

The older `GOOGLE_CLIENT_ID` key remains only as a temporary fallback. New
commands and CI/CD should use `GOOGLE_SERVER_CLIENT_ID`.

## Package behavior

`google_sign_in` 7.x is initialized with:

```dart
await GoogleSignIn.instance.initialize(
  serverClientId: AppConfig.resolvedGoogleServerClientId,
);
```

Then the provider:

1. starts user-initiated Google authentication;
2. asks Google for server authorization with scopes `openid`, `email`,
   `profile`;
3. returns `GoogleAuthorizationResult(authorizationCode: serverAuthCode)`;
4. maps cancel/configuration/unsupported/unknown errors to typed `Failure`.

## Error mapping

| Signal | Failure |
|---|---|
| Missing `GOOGLE_SERVER_CLIENT_ID` | `Failure.configuration()` |
| Missing `serverAuthCode` | `Failure.configuration()` |
| User cancelled | `Failure.cancelled()` |
| Google client/provider misconfiguration | `Failure.configuration()` |
| UI unavailable or unsupported platform | `Failure.unsupported()` |
| Backend 401 from expired app token | check `skipAuth: true` |
| Backend validation error | backend failure mapping |

Cancel should not show a red login error. Configuration errors should show a
clear setup message.

## Response handling

Backend success is expected to include Raqamli Sovchi tokens:

```json
{
  "user": {},
  "tokens": {
    "access": "<backend-access-token>",
    "refresh": "<backend-refresh-token>"
  },
  "created": true
}
```

The mobile app stores only backend `access` and `refresh` tokens through
`TokenStore`. Google auth codes and Google tokens are not stored locally.

## Tests

Required checks:

- provider returns configuration failure when server client ID is missing;
- provider returns `authorization_code` from `serverAuthCode`;
- missing server auth code maps to configuration failure;
- backend request body contains only `authorization_code`;
- backend request uses `skipAuth: true`;
- nested backend tokens are mapped and saved;
- Auth BLoC Google event reaches existing PIN gate.

## Acceptance

- Google button no longer uses custom redirect OAuth flow.
- Google button no longer opens `accounts.google.com` with
  `raqamlisovchi:/oauth2redirect`.
- Android uses native Google Sign-In.
- Backend receives `authorization_code`.
- Existing PIN setup/unlock flow continues to work after Google success.
- `flutter analyze`, format, targeted tests, and Android debug build pass.
