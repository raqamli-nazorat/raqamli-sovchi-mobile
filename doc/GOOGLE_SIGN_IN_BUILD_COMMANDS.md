# Google Sign-In build commands

The app uses the `google_sign_in` package and sends a Google `serverAuthCode`
to the backend:

```text
POST /api/v1/accounts/auth/google/
{ "authorization_code": "<serverAuthCode>" }
```

For Android, the value passed to Flutter must be the **Web application OAuth
Client ID**, not the Android OAuth Client ID.

Use this environment key:

```text
GOOGLE_SERVER_CLIENT_ID
```

The older `GOOGLE_CLIENT_ID` key is kept as a temporary fallback, but new
commands should use `GOOGLE_SERVER_CLIENT_ID`.

## Required Google Cloud clients

Create these in Google Cloud Console:

- Android OAuth client: package name + SHA-1. This identifies the Android app.
- Web application OAuth client: this is passed to Flutter as
  `GOOGLE_SERVER_CLIENT_ID` and should also match the backend Google auth
  configuration.

Do not put any Google Client Secret into the mobile app.

## Android Studio debug run

Android Studio:

```text
Run Configuration -> Additional run args
--dart-define=GOOGLE_SERVER_CLIENT_ID=39718534758-ofq6vnch4aic8g4a95ohhhccjmc630fc.apps.googleusercontent.com
```

This applies only when launching the app from that Run Configuration.

## Terminal debug run

From project root:

```powershell
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=39718534758-ofq6vnch4aic8g4a95ohhhccjmc630fc.apps.googleusercontent.com
```

## Debug APK

```powershell
flutter build apk --debug --dart-define=GOOGLE_SERVER_CLIENT_ID=39718534758-ofq6vnch4aic8g4a95ohhhccjmc630fc.apps.googleusercontent.com
```

Output:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## Release APK

```powershell
flutter build apk --release --dart-define=GOOGLE_SERVER_CLIENT_ID=39718534758-ofq6vnch4aic8g4a95ohhhccjmc630fc.apps.googleusercontent.com
```

Output:

```text
build\app\outputs\flutter-apk\app-release.apk
```

## Play Market AAB

```powershell
flutter build appbundle --release --dart-define=GOOGLE_SERVER_CLIENT_ID=39718534758-ofq6vnch4aic8g4a95ohhhccjmc630fc.apps.googleusercontent.com
```

Output:

```text
build\app\outputs\bundle\release\app-release.aab
```

## Important notes

- Android Studio `Additional run args` is not automatically used for
  `flutter build apk` or `flutter build appbundle` commands.
- If `GOOGLE_SERVER_CLIENT_ID` is missing, Google sign-in will be treated as
  not configured.
- Google OAuth Client IDs are not secrets and do not normally expire.
- Google Client Secret belongs only on the backend.
- If sign-in works in one build but not another, check package name, SHA-1, and
  the Web application client ID.
