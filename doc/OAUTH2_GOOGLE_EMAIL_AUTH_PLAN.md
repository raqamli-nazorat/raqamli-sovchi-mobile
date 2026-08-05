# Google OAuth2 Authorization Code Auth Plan

Status: implementation plan

Date: 2026-08-05

## Maqsad

Google button bosilganda Flutter ilovasi Google OAuth2 Authorization Code
flow orqali bir martalik `authorization_code` oladi. Ilova shu kodni Raqamli
Sovchi backendiga yuboradi. Backend Google bilan code exchange qiladi, userni
yaratadi yoki topadi va Raqamli Sovchi `access`/`refresh` tokenlarini qaytaradi.

Yakuniy oqim:

```text
LoginPage
  -> Google OAuth consent
  -> one-time authorization_code
  -> POST /api/v1/accounts/auth/google/
  -> backend Google token exchange
  -> Raqamli Sovchi access/refresh tokens
  -> TokenStore (flutter_secure_storage)
  -> existing PIN setup/unlock gate
  -> Home
```

## Hozirgi backend kontrakti

Swagger endpoint:

```text
POST https://backend.raqamlisovchi.uz/api/v1/accounts/auth/google/
operationId: v1_accounts_auth_google_create
Content-Type: application/json
```

Swagger request example:

```json
{
  "code": "string",
  "authorization_code": "string",
  "access_token": "string",
  "redirect_uri": ""
}
```

Backend `GoogleLoginSerializer` quyidagilarni belgilaydi:

- `code` — Google OAuth authorization code;
- `authorization_code` — `code`ning muqobil nomi;
- `access_token` — Google providerdan olingan access token;
- `redirect_uri` — ixtiyoriy, default qiymati bo‘sh string.

`code` yoki `authorization_code` ustun. Serializer kamida `code`/`authorization_code`
yoki `access_token`dan bittasini talab qiladi. Mobile app uchun ushbu plan
`authorization_code` variantini tanlaydi.

Backend `GoogleLoginView`:

1. `authorization_code`ni `code` sifatida oladi.
2. `GoogleOAuth2Adapter` orqali Google token endpointiga code exchange qiladi.
3. `redirect_uri` berilsa shu URI’dan foydalanadi; berilmasa avval
   `postmessage`, keyin backend callback URL bilan qayta urinadi.
4. Google profilini oladi va SocialAccount/User bilan bog‘laydi.
5. Yangi user uchun `201 Created`, mavjud user uchun `200 OK` qaytaradi.

Success response backend kodida quyidagi shaklda qaytariladi:

```json
{
  "user": {},
  "tokens": {
    "refresh": "<raqamli-sovchi-refresh-token>",
    "access": "<raqamli-sovchi-access-token>"
  },
  "created": true
}
```

`user` maydonining to‘liq modeli backend `UserSerializer`ga bog‘liq. Mapper
`tokens.access` va `tokens.refresh`ni alohida o‘qishi kerak; tokenlar root
darajasida deb taxmin qilinmaydi.

## 401 xatosining sababi

Berilgan javob:

```json
{
  "error": {
    "errorId": 401,
    "errorCode": "token_not_valid",
    "details": {
      "messages": [
        {
          "token_class": "AccessToken",
          "token_type": "access",
          "message": "Token is expired"
        }
      ]
    }
  }
}
```

Bu Google `authorization_code` xatosi emas. Requestga muddati tugagan
Raqamli Sovchi JWT `Authorization: Bearer ...` headeri qo‘shilgan yoki
`access_token` sifatida Raqamli Sovchi access tokeni yuborilgan.

Muhim farq:

- `authorization_code` — Google’dan OAuth login paytida yangi olinadigan,
  bir martalik va qisqa muddatli code;
- `access_token` — agar ishlatilsa, Google provider access tokeni;
- Raqamli Sovchi `access` tokeni — faqat backend API requestlari uchun;
  Google auth requestiga yuborilmaydi.

Google login public auth endpoint sifatida ishlatilgani uchun request
`skipAuth: true` bilan yuboriladi. Bu `AuthInterceptor`ning eski yoki expired
Raqamli Sovchi tokenini headerga qo‘shishiga yo‘l qo‘ymaydi.

Body bo‘lmasa, UI requestni yubormasligi kerak. Backendga yetib borgan bo‘sh
body credential validation xatosi qaytaradi; expired Sovchi JWT bilan kelgan
401 esa alohida unauthorized/network failure sifatida ko‘rsatiladi.

## Paket qarori

Ikki variant ichidan `oauth2_client` tanlanadi:

- Flutter mobil callback flowiga yaqinroq;
- authorization-code flow uchun tayyor client abstraction beradi;
- browser redirect va callback integratsiyasini `oauth2`ga qaraganda kamroq
  qo‘lda yozishni talab qiladi.

`oauth2` past darajadagi Dart OAuth2 package. Uni tanlash browser/deep-link,
state, callback va PKCE qismlarini ko‘proq o‘zimiz boshqarishimizni talab
qiladi. Shuning uchun hozircha qo‘shilmaydi.

Har ikkala holatda ham package faqat Google credential olish uchun ishlatiladi.
Raqamli Sovchi API client sifatida Dio va backend JWT lifecycle esa mavjud
`ApiClient`/`TokenStore` orqali qoladi.

## Implementatsiya bosqichlari

### 1. Google OAuth konfiguratsiyasi

Backend jamoasidan quyidagilar tasdiqlanadi:

- Android/iOS uchun qaysi Google OAuth client ID ishlatiladi;
- authorization code qaysi client ID uchun beriladi;
- `redirect_uri` qiymati `postmessage`mi yoki mobile custom scheme/app linkmi;
- PKCE talab qilinadimi;
- Android package name va SHA-1/SHA-256 fingerprintlar Google Console’da
  ro‘yxatdan o‘tganmi;
- iOS bundle ID va URL scheme sozlanganmi.

Mobile callbackda ishlatiladigan client ID backend `GoogleOAuth2Adapter`
exchange qiladigan Google app konfiguratsiyasiga mos bo‘lishi kerak. Aks holda
`invalid_grant` yoki `redirect_uri_mismatch` keladi.

### 2. Provider abstraction

`oauth2_client` domain qatlamiga kirmaydi. Data yoki core platform qatlamida
alohida abstraction bo‘ladi:

```dart
abstract interface class GoogleOAuthProvider {
  Future<GoogleAuthorizationResult> authorize();
}

final class GoogleAuthorizationResult {
  const GoogleAuthorizationResult({
    required this.authorizationCode,
    this.redirectUri,
  });

  final String authorizationCode;
  final String? redirectUri;
}
```

Provider quyidagilarni bajaradi:

- Google consent oynasini ochish;
- state/PKCE qiymatlarini boshqarish, agar konfiguratsiya talab qilsa;
- callbackdan `authorization_code`ni olish;
- cancel, timeout va provider errorni typed failurega map qilish;
- code yoki Google access tokenni log qilmaslik.

One-time authorization code secure storagega saqlanmaydi. U faqat request
vaqtida memoryda bo‘ladi.

### 3. Domain va application contract

Hozirgi `signInWithGoogle()` parametrlarsiz. U quyidagiga o‘zgartiriladi:

```dart
Future<Either<Failure, Session>> signInWithGoogle({
  required GoogleAuthorizationResult credential,
});
```

Domain `GoogleAuthorizationResult` tashqi package type emas, loyiha ichidagi
oddiy immutable model bo‘ladi. Use case provider’dan credential olib,
repositoryga uzatadi. BLoC OAuth package bilan bevosita ishlamaydi.

### 4. Backend request

Remote data source quyidagi requestni yuboradi:

```json
{
  "authorization_code": "<one-time-google-code>",
  "redirect_uri": "<exact-configured-redirect-uri>"
}
```

`redirect_uri` backend va Google Console konfiguratsiyasida default
`postmessage` ishlatilsa yuborilmasligi mumkin. URI aniq talab qilinsa,
provider qaytargan qiymat yuboriladi. Har ikkala holat backend jamoasi bilan
integratsiya testida tasdiqlanadi.

Dio request:

```dart
await _client.post<Map<String, dynamic>>(
  _googlePath,
  data: {
    'authorization_code': credential.authorizationCode,
    if (credential.redirectUri != null)
      'redirect_uri': credential.redirectUri,
  },
  options: Options(extra: {'skipAuth': true}),
);
```

### 5. Response mapper va token lifecycle

Google response uchun alohida mapper yoziladi:

1. `response.data['tokens']['access']`ni o‘qiydi.
2. `response.data['tokens']['refresh']`ni o‘qiydi.
3. `response.data['user']`ni `CurrentUserModel`/session ma’lumotiga map qiladi.
4. `access` bo‘lmasa typed `AuthContractException` qaytaradi.
5. `TokenStore.saveTokens` orqali faqat backend tokenlarini secure storagega
   yozadi.
6. `AuthBloc`ga `Session` qaytaradi va PIN gate’ni ishga tushiradi.

Backend access tokeni tugaganda mavjud refresh endpoint ishlatiladi:

```text
POST /api/v1/accounts/auth/token/refresh/
{ "refresh": "<backend-refresh-token>" }
```

Google `authorization_code` refresh uchun qayta ishlatilmaydi.

### 6. DI va feature flag

DI’da `GoogleOAuthProvider`ning bitta aniq implementationi ro‘yxatdan o‘tadi.
Provider yo‘q bo‘lsa Google button yashirin yoki aniq unavailable state’da
bo‘ladi; productionda jim temporary fallback bo‘lmaydi.

Tavsiya qilinadigan konfiguratsiya:

- `googleAuthEnabled` — feature flag;
- Google Android/iOS client ID — public config, secret emas;
- redirect URI — public config;
- backend base URL — mavjud `AppConfig` orqali.

Google client secret mobile appga qo‘yilmaydi.

## Xatolarni map qilish

| Holat | Backend/provider signali | UI natijasi |
|---|---|---|
| User cancel qildi | OAuth cancel | Login sahifasiga qaytish, qizil error ko‘rsatmaslik |
| Credential yo‘q | `code`/`authorization_code`/`access_token` yo‘q | Validation failure |
| Expired Sovchi JWT | `token_not_valid`, `AccessToken`, `Token is expired` | `skipAuth` konfiguratsiyasini tekshirish; retry |
| Google code eskirgan yoki qayta ishlatilgan | `invalid_grant`, backend validation error | Yangi Google flow boshlash |
| Redirect mos emas | `redirect_uri_mismatch` | Google/backend redirect configni tuzatish |
| User bloklangan | `403` | Backend friendly message |
| Network/offline | Dio connection/timeout | Offline/retry state |
| Backend response’da token yo‘q | mapper contract error | Auth contract error; token saqlanmaydi |

PII, authorization code, Google token va backend JWT error logga yozilmaydi.

## Test rejasi

### Unit testlar

- Google response nested `tokens.access/refresh` mapperi;
- `authorization_code` request body;
- `redirect_uri` bor/yo‘q holatlari;
- `skipAuth: true` request optioni;
- missing access token contract failure;
- `201 created` va `200 existing` response mapping;
- expired backend JWT failure mapping;
- provider cancel/timeout mapping.

### BLoC testlar

- Google requested -> loading -> PIN setup;
- Google requested -> loading -> PIN unlock;
- provider cancel -> unauthenticated, qizil error yo‘q;
- backend 401/403/400 -> expected failure state;
- mapper failure -> session/token saqlanmasligi.

### Integration test

Test Google account bilan:

1. LoginPage’dan Google button bosiladi.
2. Google consent yakunlanadi.
3. App callbackdan yangi authorization code oladi.
4. Backend requestida `Authorization` header bo‘lmaydi.
5. Body’da `authorization_code` va kerak bo‘lsa aniq `redirect_uri` bo‘ladi.
6. Backend `200` yoki `201` va nested `tokens` qaytaradi.
7. Access/refresh secure storagega yoziladi.
8. PIN setup/unlock va Home ishlaydi.

Real Google credential test loglarida yoki test snapshotlarda saqlanmaydi.

## Acceptance criteria

- Google button `This sign-in method is not available yet` holatida qolmaydi.
- App Google’dan haqiqiy one-time `authorization_code` oladi.
- `/auth/google/` requestida expired Raqamli Sovchi access tokeni yuborilmaydi.
- Backend request body `authorization_code`ga ega bo‘ladi.
- `redirect_uri` Google/backend konfiguratsiyasiga mos bo‘ladi.
- Backend `tokens.access` va `tokens.refresh` to‘g‘ri map qilinadi.
- Tokenlar faqat `flutter_secure_storage` orqali saqlanadi.
- Successdan keyin mavjud PIN gate ishlaydi.
- Cancel, invalid code, expired JWT, network va blocked user holatlari typed
  failure bilan UI’da ko‘rsatiladi.
- `flutter analyze`, format, targeted unit/BLoC/widget/integration testlar
  o‘tadi.

## Email bo‘yicha qaror

`POST /api/v1/accounts/auth/email/` OAuth2 endpoint emas. Hozirgi backend
kontrakti emailni qabul qiladi, lekin OAuth authorization code, password,
OTP yoki magic-link verification flow bermaydi. Email login shu endpoint bilan
qurilmaydi; backend alohida email auth contract chiqargandan keyin alohida
plan qilinadi.

## Manbalar

- Swagger: https://backend.raqamlisovchi.uz/api/docs/#/Accounts%20(Users)/v1_accounts_auth_google_create
- OpenAPI schema: https://backend.raqamlisovchi.uz/api/schema/
- Backend Google view: https://github.com/raqamli-nazorat/raqamli-sovchi-backend/blob/main/apps/accounts/users/views.py
- Backend Google serializer: https://github.com/raqamli-nazorat/raqamli-sovchi-backend/blob/main/apps/accounts/users/serializers.py
- `oauth2_client`: https://pub.dev/packages/oauth2_client
- `oauth2`: https://pub.dev/packages/oauth2

## Yakuniy qaror

`oauth2_client` + Authorization Code flow tanlanadi. App Google’dan olingan
`authorization_code`ni `POST /api/v1/accounts/auth/google/` endpointiga
`skipAuth: true` bilan yuboradi. Backend qaytargan nested Raqamli Sovchi
`tokens` secure storagega yoziladi. Google access token yoki expired Sovchi
JWTni aralashtirish taqiqlanadi.
