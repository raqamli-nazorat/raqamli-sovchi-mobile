# Telegram Auth, Local PIN, and Biometric Unlock Plan

## Implementation Status

Implemented in the Flutter app:

- Telegram session create/status API, bot URL launch, 2-second polling, cancel,
  expiry handling, app-resume status check, and secure token mapping.
- Telegram success -> existing PIN setup/unlock gate.
- Local biometric availability check and unlock with PIN fallback.
- Android `FlutterFragmentActivity`/biometric permission and iOS Face ID usage
  description.
- DTO, BLoC, PIN, and biometric focused tests.

The phone OTP temporary adapter remains available in development; Telegram uses
the explicit remote Telegram data source even while the phone adapter is local.

## Maqsad

Telegram bot orqali ro'yxatdan o'tish yoki kirish flowini mobil ilovaga ulash, login muvaffaqiyatli bo'lgandan keyin 4 xonali lokal PIN yaratish, keyingi app ochilishlarida esa PIN unlock ekranini ko'rsatish. Biometrik unlock PIN fallbackni almashtirmaydi; u faqat mavjud lokal sessiyani tez ochish uchun ishlatiladi.

## Backenddan O'rganilgan Holat

Manbalar:

- API docs:
  - `POST /api/v1/accounts/telegram-bot/auth-session/create/`
  - `GET /api/v1/accounts/telegram-bot/auth-session/{session_id}/status/`
- Backend code:
  - `apps/accounts/telegram_bot/views.py`
  - `apps/accounts/telegram_bot/serializers.py`
  - `apps/accounts/telegram_bot/models.py`
  - `apps/accounts/telegram_bot/bot/handlers.py`
  - `apps/accounts/telegram_bot/urls.py`

Backend flow quyidagicha:

1. Mobile app `auth-session/create/` endpointiga `POST` yuboradi. Request body yo'q.
2. Backend `TelegramAuthSession` yaratadi.
3. Response ichida `session_id`, `status`, `bot_url`, `expires_at`, `created_at` qaytadi.
4. `bot_url` format: `https://t.me/{bot_username}?start={session_id}`.
5. Mobile app `bot_url`ni ochadi.
6. Telegram bot `/start <session_id>` commandini oladi.
7. Bot session `pending` va muddati o'tmaganligini tekshiradi.
8. Bot foydalanuvchidan contact share qilishni so'raydi.
9. Foydalanuvchi telefon raqamini Telegram contact tugmasi orqali yuboradi.
10. Bot `User`ni telefon raqam bilan topadi yoki yaratadi.
11. Bot SimpleJWT access va refresh token yaratadi.
12. Bot session statusini `authenticated` qiladi va tokenlarni sessionga yozadi.
13. Mobile app status endpointini BLoC timer orqali poll qiladi.
14. Status `authenticated` bo'lsa response ichida `user` va `tokens` keladi.
15. Mobile app tokenlarni secure storagega saqlaydi, user sessionni yaratadi, keyin PIN gatega o'tadi.

## API Contract

### Create Session

```http
POST /api/v1/accounts/telegram-bot/auth-session/create/
```

Request:

```json
null
```

Expected response:

```json
{
  "session_id": "uuid",
  "status": "pending",
  "bot_url": "https://t.me/RaqamliSovchiBot?start=uuid",
  "expires_at": "datetime",
  "created_at": "datetime"
}
```

### Check Session Status

```http
GET /api/v1/accounts/telegram-bot/auth-session/{session_id}/status/
```

Pending response:

```json
{
  "status": "pending"
}
```

Expired response:

```json
{
  "status": "expired"
}
```

Authenticated response:

```json
{
  "status": "authenticated",
  "user": {
    "id": "user-id",
    "phone_number": "+998901234567",
    "full_name": ""
  },
  "tokens": {
    "access": "jwt-access",
    "refresh": "jwt-refresh"
  }
}
```

Session lifetime backend model bo'yicha 5 daqiqa.

## Mobile Telegram Flow

Telegram button bosilganda:

1. `AuthTelegramSignInRequested` event dispatch qilinadi.
2. Auth BLoC loading statega o'tadi.
3. `CreateTelegramAuthSessionUseCase` chaqiriladi.
4. Remote data source `POST auth-session/create/` chaqiradi.
5. Response ichidagi `bot_url` olinadi.
6. Remote Telegram data source `url_launcher` orqali Telegram deep linkni ochadi.
7. Auth BLoC status pollingni boshlaydi.
8. Har 2 sekundda `GET auth-session/{session_id}/status/` chaqiriladi.
9. Polling quyidagi holatlarda to'xtaydi:
   - `authenticated`: tokenlar saqlanadi, session emit qilinadi.
   - `expired`: failure emit qilinadi, user qayta urinadi.
   - timeout: 5 daqiqadan keyin polling to'xtaydi.
   - user cancel/back: polling cancel qilinadi.
10. `authenticated` bo'lsa `AuthBloc._emitPinGate(session)` ishlaydi.
11. Agar lokal PIN yo'q bo'lsa `/pin/create`.
12. Agar lokal PIN bor bo'lsa `/pin/unlock`.

Minimal UI:

- Telegram button bosilgandan keyin loading ko'rsatish.
- Telegram ochilganidan keyin "Telegramda telefon raqamingizni yuboring, keyin ilovaga qayting" holatini ko'rsatish.
- Polling davomida cancel/back ishlashi kerak.
- Expired bo'lsa "Sessiya muddati tugadi. Qayta urinib ko'ring" xabari.

## Flutter Arxitektura

Feature-first tuzilma shu feature ichida qoladi:

```text
lib/features/auth/
  domain/entities/
    telegram_auth_session.dart
  application/use_cases/
    create_telegram_auth_session.dart
    get_telegram_auth_session_status.dart
  data/models/
    telegram_auth_session_model.dart
    telegram_auth_status_model.dart
  data/data_sources/
    telegram_auth_data_source.dart
  data/repositories/
    auth_repository_impl.dart
  presentation/bloc/
    auth_bloc.dart
    auth_event.dart
    auth_state.dart
```

Repository contractga qo'shiladi:

```dart
Future<Either<Failure, TelegramAuthSession>> createTelegramAuthSession();

Future<Either<Failure, TelegramAuthStatus>> getTelegramAuthSessionStatus(
  String sessionId,
);
```

Ponytail qarori: alohida Telegram BLoC kerak emas. Auth flow bitta BLoCda
ketmoqda; polling `Timer` va cancel handle AuthBloc ichida qoladi.

## Token Mapping

Backend authenticated response tokenlarni nested `tokens` ichida qaytaradi. Hozirgi `AuthSessionModel.fromJson` esa rootda `access`, `access_token`, `refresh`, `refresh_token` qidiradi. Shuning uchun Telegram status mapper alohida bo'lishi kerak.

Mapper qoidasi:

- `accessToken = json["tokens"]["access"]`
- `refreshToken = json["tokens"]["refresh"]`
- `userId = json["user"]["id"]`
- `displayName = json["user"]["full_name"] ?? "Raqamli Sovchi"`
- `phoneNumber = json["user"]["phone_number"]`
- `isVerified = true`

Tokenlar faqat `TokenStore` orqali secure storagega yoziladi.

## Deep Link va App Lifecycle

Telegram bot URL tashqi appga olib chiqadi. Mobile app status pollingni ikki xil yo'l bilan boshqarishi mumkin:

1. App foregroundda qolsa polling davom etadi.
2. App backgroundga o'tsa timer platform tomonidan sekinlashishi mumkin; app
   resume bo'lganda `AuthApplicationResumed` statusni darhol tekshiradi.

Minimal implementation:

- `url_launcher` bilan `bot_url` ochiladi.
- App lifecycle observer `App`ga qo'shiladi.
- `resumed` holatida active Telegram session bor bo'lsa status tekshiriladi.
- Polling uchun `Timer.periodic` yoki stream ishlatiladi.

Universal/deep link callback hozir shart emas, chunki backend flow status pollingga asoslangan.

## PIN Flow

Hozirgi loyiha PIN uchun kerakli asosiy qismlarga ega:

- `PinPage(mode: create | unlock)`
- `SecurePinDataSource`
- `PinRepository`
- `CreatePinUseCase`
- `HasPinUseCase`
- `VerifyPinUseCase`
- Auth router redirect:
  - `pinSetupRequired` -> `/pin/create`
  - `pinLocked` -> `/pin/unlock`

Kutilgan flow:

1. User phone, OTP, Telegram yoki Google orqali login qiladi.
2. Tokenlar secure storagega saqlanadi.
3. Auth BLoC `hasPin()` tekshiradi.
4. PIN yo'q bo'lsa `/pin/create`.
5. User 4 xonali PIN kiritadi.
6. PIN `flutter_secure_storage` ichida `auth.local_pin` key bilan saqlanadi.
7. App `authenticated` bo'ladi.
8. App qayta ochilganda `AuthStarted` token orqali sessiyani restore qiladi.
9. `hasPin() == true` bo'lsa user `/pin/unlock`ga tushadi.
10. To'g'ri PIN kiritilsa `authenticated`.
11. Logout bo'lsa tokenlar va PIN tozalanadi.

Muhim qaror: PIN backendga yuborilmaydi. PIN local-only.

## Biometric Unlock

Biometrika PINni almashtirmaydi. Faqat `/pin/unlock` ekranida mavjud lokal sessiyani ochish uchun shortcut.

Paket:

```yaml
dependencies:
  local_auth:
```

Yangi core service:

```text
lib/core/security/biometric_auth_service.dart
```

Public API:

```dart
enum BiometricAvailability {
  available,
  notSupported,
  notEnrolled,
  unavailable,
}

enum BiometricAuthResult {
  success,
  userCanceled,
  failed,
  lockedOut,
  unavailable,
}

abstract interface class BiometricAuthService {
  Future<BiometricAvailability> checkAvailability();
  Future<BiometricAuthResult> authenticate();
}
```

PIN unlock flow:

1. `/pin/unlock` ochiladi.
2. App biometric availabilityni tekshiradi.
3. `available` bo'lsa fingerprint icon ko'rsatiladi.
4. User biometric buttonni bosadi.
5. OS prompt ochiladi.
6. Result `success` bo'lsa token borligi tekshiriladi.
7. Token bor bo'lsa `AuthStatus.authenticated`.
8. Token yo'q bo'lsa `AuthStatus.unauthenticated` va login page.
9. User cancel, failed, lockedOut, unavailable holatlarida PIN fallback doim ishlaydi.

Platform setup:

Android:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

`MainActivity`:

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

iOS:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Hisobingizga tez va xavfsiz kirish uchun Face ID ishlatiladi.</string>
```

## Security Qarorlar

- Telegram session ID secret emas, lekin qisqa muddatli auth handoff token sifatida ehtiyotkor ishlatiladi.
- Session ID log qilinmaydi.
- `bot_url` analyticsga to'liq yuborilmaydi.
- Access va refresh tokenlar faqat secure storagega yoziladi.
- PIN faqat secure storagega yoziladi.
- Biometrika token yaratmaydi, backend login qilmaydi, PINni o'qimaydi.
- Logout tokenlar va PINni tozalaydi.
- Expired Telegram sessiondan token olinmaydi.

## Error Caselar

Telegram:

- `create` network error: login page error state.
- Telegram app o'rnatilmagan: browser fallback bilan `https://t.me/...` ochish.
- Bot start session topilmagan yoki expired: status polling ham expired/not found qaytaradi, user qayta urinadi.
- User contact yubormadi: polling pending qoladi; timeoutdan keyin expired/cancel.
- Status 404: session not found failure.
- Status authenticated, lekin token yo'q: contract failure.

PIN:

- PIN yaratishda 4 digit bo'lmasa event ignore.
- Noto'g'ri PIN: `/pin/unlock`da validation failure.
- Secure storage error: typed failure.
- Logout: PIN clear.

Biometric:

- Device unsupported yoki not enrolled: biometric button yashiriladi.
- User cancel: error ko'rsatilmaydi, PIN fallback.
- Lockout: "PIN orqali davom eting".
- Token yo'q: login page.

## Implementation Bosqichlari

### 1. Telegram API Contract

- `TelegramAuthSession` entity.
- `TelegramAuthStatus` entity.
- DTO va mapperlar.
- `TelegramAuthDataSource.createSession()`.
- `TelegramAuthDataSource.getSessionStatus(sessionId)`.
- Repository methodlar.
- Failure mapping.

### 2. Telegram Button Flow

- `AuthTelegramSignInRequested` real flowga ulanadi.
- `url_launcher` qo'shiladi.
- Bot URL ochiladi.
- Polling boshlanadi.
- Polling cancel va timeout qo'shiladi.
- `authenticated` status tokenlarni saqlaydi.
- `AuthBloc._emitPinGate(session)` chaqiriladi.

### 3. PIN Gate Audit

- Login successdan keyin har doim `_emitPinGate`.
- Restore sessionda token bor bo'lsa `hasPin()` tekshiriladi.
- PIN bor bo'lsa `/pin/unlock`.
- PIN yo'q bo'lsa `/pin/create`.
- Logoutda `clearPin()`.

### 4. Biometric Unlock

- `local_auth` dependency.
- Android/iOS platform setup.
- `BiometricAuthService`.
- Auth BLoCga `AuthBiometricUnlockRequested`.
- PIN page fingerprint buttonni real servicega ulash.
- Token mavjudligini tekshirish.
- PIN fallbackni buzmaslik.

### 5. Tests

- Telegram create session DTO mapping.
- Telegram status pending/expired/authenticated mapping.
- Missing token contract failure.
- Auth BLoC Telegram polling success -> pin create.
- Auth BLoC Telegram polling success + existing pin -> pin unlock.
- Polling expired -> failure.
- PIN save/restore/unlock.
- Biometric success token bor -> authenticated.
- Biometric success token yo'q -> unauthenticated.
- Biometric cancel -> pinLocked.

## Acceptance Criteria

- Telegram button bosilganda backend session yaratiladi.
- `bot_url` Telegram yoki browser orqali ochiladi.
- Botda contact yuborilgandan keyin app status polling orqali token oladi.
- Tokenlar secure storagega saqlanadi.
- Telegram login successdan keyin PIN gate ishlaydi.
- Birinchi kirishda `/pin/create`.
- Keyingi app ochilishida token + local PIN bo'lsa `/pin/unlock`.
- PIN local-only va secure storage ichida.
- Biometric unlock faqat `/pin/unlock`da mavjud bo'ladi.
- Biometric ishlamasa PIN fallback doim ishlaydi.
- Logout token va PINni tozalaydi.
- `flutter analyze` va relevant testlar o'tadi.

## Open Savollar

1. Telegram session status polling intervali nechchi sekund bo'lsin?

   Tavsiya: 2 sekund.

2. Polling maksimal qancha davom etsin?

   Tavsiya: backend expiry bilan bir xil, 5 daqiqa.

3. Telegram app o'rnatilmagan bo'lsa browser fallback yetarlimi?

   Tavsiya: ha, `https://t.me/...` browser orqali ochiladi.

4. Biometric unlock uchun user sozlamadan opt-in qilishi kerakmi?

   Tavsiya: hozircha yo'q. Faqat available bo'lsa shortcut ko'rsatish yetarli.

5. Logout PINni ham o'chiradimi?

   Hozirgi implementation o'chiradi. Xavfsiz default shu.

## Sources

- API docs: `https://backend.raqamlisovchi.uz/api/docs/#/Accounts%20(Telegram_bot)/v1_accounts_telegram_bot_auth_session_create_create`
- API docs: `https://backend.raqamlisovchi.uz/api/docs/#/Accounts%20(Telegram_bot)/v1_accounts_telegram_bot_auth_session_status_retrieve`
- Backend folder: `https://github.com/raqamli-nazorat/raqamli-sovchi-backend/tree/main/apps/accounts/telegram_bot`
