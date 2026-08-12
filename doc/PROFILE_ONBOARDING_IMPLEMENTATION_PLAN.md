# Profil anketasi va lokal draft implementation rejasi

Holat: reja, implementation boshlanmagan

Oxirgi yangilanish: 2026-08-08

## 1. Maqsad

Login va PIN tasdiqlangandan keyin `status == "Anketa to'liq emas"` bo'lgan
foydalanuvchini profil anketasiga olib kirish. Candidate type, pledge va anketa
maydonlari avval lokal draft sifatida saqlanadi. Surat tanlanganda esa rasm
darhol backendga multipart upload qilinadi; asosiy surat va face verification
ham o'z stepida backend bilan ishlaydi.

Auth response'dagi access va refresh tokenlar ham login vaqtida doimiy
`TokenStore`ga yozilmaydi. Ular onboarding davomida faqat process xotirasidagi
pending session ichida turadi. Yakuniy harakat muvaffaqiyatli tugagandagina
secure storage'ga ko'chiriladi.

Final submissionning birinchi so'rovi `POST /api/v1/accounts/profiles/` bo'ladi.
Undan keyingi pledge va boshqa qolgan so'rovlar tartibi backend contractlari
aniqlashtirilgach yakunlanadi.

## 2. Manbalar

### Figma

- Candidate type: `18:85`
- Ishonch pledge: `18:114`
- Tug'ilgan sana/yil: `424:4204`
- Ism-familiya: `424:4251`
- Ta'lim: `424:4265`
- Bo'y: `424:4284`
- Viloyat va tuman: `424:4331`
- Surat qo'shish: `424:13197`
- Ovozli tanishtiruv: `424:13218`
- Asosiy surat: `424:13265`
- Rasm/selfie tekshiruvi: `424:13316`
- Anketa tayyor: `424:13487`

Figma context va screenshotlar 390 px kenglikdagi iPhone frame'lari bo'yicha
tekshirildi. Asosiy vizual qoidalar: Manrope, oq fon, 24/30 bold sarlavha,
24 px gorizontal padding, 342 px pill button, 3 px progress bar va ko'k
`#0474F3` primary rang.

### Backend

- `GET /api/v1/references/education-levels/`
- `GET /api/v1/locations/region/`
- `GET /api/v1/locations/district/?region=<region_uuid>`
- `POST /api/v1/accounts/photos/` - surat tanlanganda multipart upload
- `GET /api/v1/accounts/photos/` - asosiy surat stepida server rasmlari
- `PATCH /api/v1/accounts/photos/{id}/` - `is_main` va kerak bo'lsa `order`
- `PUT /api/v1/accounts/photos/{id}/` - to'liq update zarur bo'lsagina
- `POST /api/v1/accounts/face-verify/` - selfie multipart verification
- `POST /api/v1/accounts/profiles/` - final submissionning birinchi so'rovi
- `POST /api/v1/accounts/pledges/` - final submission, keyingi tartib TBD

`GET /api/v1/accounts/profiles/me/` bu ish doirasida chaqirilmaydi.

Reference endpointlar paginated javob beradi:

```text
{ count, next, previous, results }
```

Education result uchun `id`, `name`; region uchun `id`, `name`, `code`;
district uchun `id`, `name`, `region_info` kerak.

### Face verification qarori

Identity match qurilmada MobileFaceNet bilan bajarilmaydi. App kameradan selfie
oladi, ML Kit orqali yuborishdan oldingi yuz/ko'z quality gate'ini bajaradi va
selfie'ni `POST /api/v1/accounts/face-verify/` endpointiga multipart yuboradi.
Match qarori backenddan keladi.

OpenAPI schema hozir ushbu endpoint uchun request body va response body'ni
ko'rsatmaydi. Form-data field nomi, success/mismatch statuslari va error payload
backend bilan aniqlashtirilishi kerak.

## 3. Tasdiqlangan oqim

```text
Login response
  -> pending session (token RAM'da)
  -> OTP/Google/Telegram tasdiqlash
  -> PIN yaratish yoki PIN kiritish
  -> status gate
  -> Candidate type (lokal draft)
     -> groom/bride: Pledge (lokal draft) -> Questionnaire PageView
     -> representative: alohida 6-step vakil flow
  -> Photo upload (tanlanganda backendga)
  -> Main photo GET/PATCH
  -> Backend face verification
  -> Final page
  -> POST /accounts/profiles/ (birinchi final so'rov)
  -> qolgan final API operatsiyalari (tartibi TBD)
  -> tokenlarni secure storage'ga commit
  -> Home yoki AI moslik testi
```

`candidate_type` va pledge ekranlari alohida route bo'lib qolishi mumkin.
Pledge'dagi `Anketani boshlash` tugmasi questionnaire route'ini ochadi.
Questionnaire ichidagi 9 bosqich bitta boshqariladigan `PageView` bo'ladi.
Kuyov va kelin shu umumiy questionnaire'dan foydalanadi. `representative`
tanlansa pledge/general questionnaire'ga emas, `USER_FLOW_MAP.md`dagi alohida
6-step vakil onboarding flowiga o'tadi.

Questionnaire'dagi barcha 9 step majburiy. Figma'dagi education, photo, audio
va face-check skip actionlari olib tashlanadi.

Swipe orqali validatsiyani chetlab o'tmaslik uchun `PageView`da user swipe
o'chiriladi. Oldinga va orqaga yurish faqat header back va action buttonlar
orqali boshqariladi.

## 4. Auth va pending token rejasi

### Hozirgi muammo

Phone OTP, Google va Telegram data source'lari tokenni login javobidan keyin
darhol `TokenStore`ga yozmoqda. Shu sabab app qayta ochilganda anketa tugamagan
foydalanuvchi authenticated hisoblanadi.

### Kerakli o'zgarish

Barcha providerlar bir xil qoidaga o'tadi:

1. Backend auth response parse qilinadi.
2. Session va token jufti `PendingAuthSession` sifatida faqat RAM'da saqlanadi.
3. PIN va onboarding shu pending session bilan ishlaydi.
4. Auth talab qiladigan reference va yakuniy API so'rovlarida interceptor
   pending access tokenni ishlata oladi.
5. Yakun muvaffaqiyatli bo'lsa `commitPendingTokens()` access/refresh tokenlarni
   bitta nazorat qilinadigan commit jarayonida `flutter_secure_storage`ga yozadi;
   juftlikdan biri yozilmasa authenticated holat emit qilinmaydi.
6. Cancel, sign out, provider almashtirish yoki fatal auth xatosida pending
   tokenlar xotiradan tozalanadi.

Minimal yechim: mavjud `TokenStore` persistent storage vazifasini saqlaydi;
uning oldiga bitta `AuthSessionManager` qo'yiladi. Manager pending tokenni RAM'da
ushlaydi, interceptor uchun effective tokenni qaytaradi va final commitni
boshqaradi. Token oddiy preferences, draft JSON yoki media metadata ichiga
yozilmaydi.

Process o'lsa pending token yo'qoladi. Bu ataylab qilingan xavfsizlik qarori.
Foydalanuvchi qayta login qiladi, lekin oldingi questionnaire draft qayta
tiklanadi.

## 5. Lokal draft modeli

Domain nomi: `ProfileOnboardingDraft`.

```text
ownerUserId
currentStep
candidateType
pledgeAcceptedTerms
pledgeHasSeriousBadge
birthDate
birthYear (backendning hozirgi fieldi uchun derived qiymat)
firstName
lastName
educationLevelId
educationLevelName
heightCm
regionId
regionName
districtId
districtName
photos[]
mainPhotoServerId
voiceIntro
faceVerification
updatedAt
schemaVersion
```

Har bir photo metadata:

```text
localId
privateFilePath
serverId
profileId
imageUrl
mimeType
sizeBytes
width
height
order
isMain
source(camera/gallery)
uploadStatus
uploadFailure
```

Audio metadata:

```text
privateFilePath
mimeType
codec
durationMs
sizeBytes
```

Face verification metadata faqat natijani saqlaydi:

```text
status: notStarted | processing | matched | failed
serverResult
verifiedAt
```

Selfie fayli draftda saqlanmaydi. Figma talabiga ko'ra tekshiruvdan keyin
o'chiriladi.

### Storage

- Kichik draft metadata mavjud `SecureStorage`da versionlangan JSON sifatida.
- Upload tugamaguncha photo va final submitgacha audio app-private directory
  ichida turadi.
- Gallery'ga nusxa yozilmaydi.
- Photo qabul qilinganda EXIF metadata olib tashlanadi va orientation bake
  qilinadi.
- Photo upload muvaffaqiyatli bo'lsa server `id`, `profile`, `image`, `order` va
  `is_main` draftga yoziladi; retry ehtiyoji qolmasa lokal photo file o'chiriladi.
- Photo/audio o'chirilsa eski lokal fayl darhol o'chiriladi.
- Final submit muvaffaqiyatli tugasa yoki account/sign-out oqimi bajarilsa
  draft va private media tozalanadi.
- Boshqa user login qilsa `ownerUserId` mos bo'lmagan draft ochilmaydi.

DB dependency hozir kerak emas. Bitta kichik draft uchun secure JSON va private
file storage yetarli. Draft hajmi yoki ko'p profil/vakil draftlari paydo bo'lsa
keyin SQLite/Isar qayta baholanadi.

## 6. State management

### AuthBloc chegarasi

`AuthBloc` login, pending session, PIN va yuqori darajadagi route gate'ni
boshqaradi. Candidate type va pledge API use case'lari undan chiqariladi.

Kerakli auth holatlari:

```text
candidateTypeRequired
pledgeRequired
questionnaireRequired
authenticated
```

### ProfileOnboardingBloc

Questionnaire uchun bitta `ProfileOnboardingBloc` ishlatiladi. Har page uchun
alohida Bloc yaratilmaydi.

Mas'uliyatlari:

- draftni load/save qilish;
- current step va progressni boshqarish;
- har step validatsiyasi;
- reference listlarni olish;
- region o'zgarganda districtni tozalash;
- photo/audio metadata boshqaruvi;
- main photo tanlash;
- face verification state;
- final submissionni keyinchalik orchestration qilish.

Text controller, focus va lokal animation kabi mayda UI state widget ichida
qoladi. Business draft faqat Bloc state orqali yuradi.

## 7. UI bosqichlari

### 7.1 Candidate type - `18:85`

- Uch variant: `groom`, `bride`, `representative`.
- Figma'dagi default selected groom saqlanadi.
- `Davom etish` API chaqirmaydi.
- Tanlov draftga yoziladi va pledge route ochiladi.
- Back bosilganda tanlov draftda qoladi.
- Kuyov va kelin umumiy questionnaire'ga o'tadi.
- Vakil darhol `USER_FLOW_MAP.md`dagi alohida 6-step vakil onboarding flowiga
  o'tadi. General candidate questionnaire vakil uchun ochilmaydi.

### 7.2 Pledge - `18:114`

- Pledge checkbox roziligisiz button disabled.
- `accepted_terms` va `has_serious_badge` draftga yoziladi.
- `/accounts/pledges/` chaqirilmaydi.
- `Anketani boshlash` questionnaire PageView'ni ochadi.

### 7.3 Tug'ilgan sana/yil - `424:4204`, 11%

Figma'dagi uch ustunli kun/oy/yil wheel picker to'liq saqlanadi. Draftda to'liq
`birthDate` turadi. Backend hozir faqat `birth_year` qabul qilgani uchun final
payloadga `birthDate.year` yuboriladi; to'liq sana keyingi backend field
qo'shilganda shu draft qiymatidan yuboriladi.

Validatsiya:

- bo'sh bo'lmasin;
- yosh kun/oy/yil bilan aniq hisoblanadi;
- faqat 18 yoshga to'lgan va 61 yoshga hali to'lmagan foydalanuvchi qabul
  qilinadi, ya'ni valid yosh `18 <= age <= 60`;
- picker yillari boundary tug'ilgan kunlarni ham qamrab oladi, yakuniy qaror esa
  exact date orqali beriladi;
- masalan 2026-08-08 kuni valid DOB oralig'i 1965-08-09 dan 2008-08-08 gacha;
  bu exact 18-60 yoshni saqlaydi;
- leap year va 29-fevral holati test qilinadi;
- joriy sana testda boshqariladigan `Clock` orqali olinadi.

### 7.4 Ism-familiya - `424:4251`, 22%

Figma uslubi saqlanadi, lekin ekranda alohida `Ism` va `Familiya` underline
inputlari bo'ladi. Full name parsing qilinmaydi.

Validatsiya:

- trim qilingan bo'sh qiymat qabul qilinmaydi;
- har maydon backend limitiga ko'ra 100 belgidan oshmaydi;
- raqam va faqat punctuation qabul qilinmaydi;
- Unicode ism belgilarini sun'iy ravishda lotinga cheklamaslik.

### 7.5 Ta'lim - `424:4265`, 33%

- Chiplar backend `education-levels` natijasidan yaratiladi.
- Tanlov `educationLevelId` bilan saqlanadi; UI uchun name ham draftda turadi.
- `Keyinroq aytaman` chipi olib tashlanadi; ta'lim tanlash majburiy.
- Figma'da bir tanlovli chips wrap layout.
- Loading skeleton, retry error va empty state bo'ladi.
- Bir session ichida olingan list memory cache'da qayta ishlatiladi.
- Pagination `next` tugaguncha olinadi yoki bottom sheet/list lazy pagination
  qiladi; birinchi page bilan cheklanmaydi.

### 7.6 Bo'y - `424:4284`, 44%

- Markazda selected value, `-` va `+` tugmalari, pastda ruler.
- Tap step 1 cm.
- Long press takrorlash ixtiyoriy; birinchi versiyada shart emas.
- Draftga integer `heightCm` yoziladi.
- Minimum 100 sm, maksimum 300 sm.
- Accessibility uchun qiymat va increment/decrement semantic label beriladi.

### 7.7 Viloyat va tuman - `424:4331`, 56%

- Viloyat va tuman alohida selector field.
- Tap bo'lganda reusable custom `AppSelectionBottomSheet` ochiladi.
- Bottom sheet title, search, loading, retry, empty, selected check va paginated
  list holatlarini qo'llaydi.
- Region GET: `/api/v1/locations/region/`.
- District GET: `/api/v1/locations/district/?region=<uuid>`.
- Region tanlanmaguncha district field disabled.
- Region o'zgarsa avvalgi district darhol null qilinadi.
- District response qaytguncha oldingi list ko'rsatilmaydi.
- Request race condition oldini olish uchun eski region request natijasi
  active tanlovga mos bo'lmasa tashlanadi.

### 7.8 Suratlar - `424:13197`, 67%

- 2x2 grid, maksimal 4 surat.
- Bo'sh slot tap: `Kamera` va `Galereya` custom bottom sheet.
- `O'tkazib yuborish` olib tashlanadi; kamida bitta surat majburiy.
- Cancel qilingan picker error hisoblanmaydi.
- Permission denied va permanently denied alohida UI holati.
- Qabul qilinadigan MIME: JPEG/PNG; HEIC platformda decode/convert tekshiriladi.
- Fayl o'lchami, dimension, corruption va aniq yuz borligi tekshiriladi.
- Compression va EXIF stripping private file'ga ko'chirishdan oldin bajariladi.
- Maksimal upload hajmi backend bilan tasdiqlanmaguncha configda saqlanadi.
- Har qabul qilingan surat `POST /api/v1/accounts/photos/` orqali darhol
  multipart/form-data qilib upload qilinadi.
- Create payload schema bo'yicha `image` va `profile` UUID majburiy; `order` va
  `is_main` ham yuborilishi mumkin.
- Slot upload davomida progress/loading ko'rsatadi; xatoda retry va remove
  actionlari chiqadi.
- `Davom etish` kamida bitta upload serverda muvaffaqiyatli tugamaguncha
  disabled.
- Server photo `id` va URL draftga yoziladi; app restartdan keyin GET bilan
  reconcile qilinadi.
- Server URL uchun `CachedNetworkImage`, hali upload bo'lmagan lokal preview
  uchun `Image.file` ishlatiladi. `CachedNetworkImage` lokal file pathni
  render qilmaydi; bitta `AppProfileImage` source turiga qarab ikkalasini
  yashiradi.

### 7.9 Ovozli tanishtiruv - `424:13218`, 78%

- Idle, requestingPermission, recording, paused, preview, failed state'lari.
- Record, stop, cancel, qayta yozish va playback mavjud.
- `O'tkazib yuborish` olib tashlanadi; ovozli tanishtiruv majburiy.
- Format: AAC-LC, M4A container, mono, 44.1 kHz, 64 kbps.
- Maksimal duration 30 soniya; vaqt tugaganda recording avtomatik to'xtaydi.
- 64 kbps bilan 30 soniya taxminan 240 KB audio beradi. Container va platform
  farqi uchun client hard limit 1 MB qilinadi.
- App background/inactive bo'lsa recording xavfsiz to'xtatiladi.
- Temporary recording almashtirilsa eski file o'chiriladi.
- Final profile multipart payloadida `voice_intro` sifatida yuboriladi.
- Kelajak candidate detail playback shu format va backend qaytargan URL bilan
  `just_audio` orqali ishlashi uchun recorder/player contract ajratiladi.

Backend AAC/M4A qabul qiladi. MP3 conversion va FFmpeg dependency kerak emas.

### 7.10 Asosiy surat - `424:13265`, 89%

- Page ochilganda `GET /api/v1/accounts/photos/` chaqiriladi va pagination
  tugaguncha server rasmlari olinadi.
- Barcha server rasmlari 2x2 gridda ko'rinadi.
- Istalgan surat `Asosiy qilish` orqali tanlanadi.
- Tanlov `PATCH /api/v1/accounts/photos/{id}/` payloadidagi
  `{ "is_main": true }` bilan yuboriladi. Partial update bu action uchun PUT'dan
  kichik va xavfsizroq.
- Bitta `mainPhotoServerId` bo'lishi shart.
- Surat yo'q bo'lsa shu page'dan kamera/galereya ochiladi.
- Shu page'dan qo'shilgan surat ham darhol POST qilinadi, so'ng list refresh
  yoki local response merge qilinadi.
- `Davom etish` kamida bitta server surati va main update muvaffaqiyatli bo'lmasa
  disabled.
- Main surat o'chirilsa boshqa surat avtomatik main qilinmaydi; user qayta
  tanlaydi.
- Photo order stabil server `id` bilan yuradi, list index bilan emas.
- Backend yangi `is_main=true` bo'lganda oldingi mainni avtomatik false qilishi
  tasdiqlanishi kerak. Qilmasa client eski mainni ham PATCH qiladi.

### 7.11 Rasm tekshiruvi - `424:13316`

Figma'da asosiy surat va live selfie yonma-yon, match natijasi va tavsiyalar bor.
`Keyinroq` actioni olib tashlanadi; face check majburiy.

Pipeline:

1. Main photo serverda `is_main=true` bo'lishi tekshiriladi.
2. Camera permission so'raladi.
3. Live/selfie capture'da ML Kit orqali aniq bitta yuz talab qilinadi.
4. ML Kit classification bilan ikkala ko'z ko'rinishi/ochiqligi tekshiriladi.
5. Yaw/roll chegarasi bilan frontal pose va yetarli face size talab qilinadi.
6. Selfie app-private temporary file sifatida yoziladi.
7. Selfie `POST /api/v1/accounts/face-verify/` endpointiga multipart yuboriladi.
8. Backend success bo'lsa draft `matched`; mismatch/error bo'lsa retry UI.
9. Selfie file response olingach yoki flow bekor qilinsa o'chiriladi.

App identity embedding yoki cosine similarity hisoblamaydi. `tflite_flutter`
va MobileFaceNet model dependencylari qo'shilmaydi. ML Kit faqat yuborishdan
oldingi quality gate uchun ishlaydi; identity qarori backendga tegishli.

### 7.12 Yakun - `424:13487`

- Success icon, `Anketangiz tayyor!`, AI test card.
- Primary: `Ha, testni boshlayman`.
- Secondary: `Keyinroq — avval nomzodlarni ko'raman`.
- Double tap paytida takror submit/commit bo'lmasligi uchun action loading va
  disabled holatga o'tadi.
- API submit muvaffaqiyatsiz bo'lsa draft saqlanadi, home ochilmaydi va token
  commit qilinmaydi.
- `Keyinroq` finalization muvaffaqiyatidan keyin tokenlarni commit qilib Home'ga
  o'tadi.
- `Ha, testni boshlayman` ham finalizationdan keyin tokenlarni commit qiladi va
  AI moslik testi route'iga o'tadi.
- Token ikkala actionda ham faqat majburiy final APIlar muvaffaqiyatli
  tugagandan keyin persist qilinadi.

## 8. Reference API data layer

Onboarding feature ichida quyidagi minimal contractlar yetarli:

```text
EducationLevelRepository.getEducationLevels()
LocationRepository.getRegions()
LocationRepository.getDistricts(regionId)
```

Data layer:

- Dio orqali GET;
- paginated wrapper uchun aniq model nomlari;
- `EducationLevelModel`, `RegionModel`, `DistrictModel`;
- domain entityga mapper;
- `DioException`ni typed `Failure`ga map qilish;
- UI'ga raw JSON yoki Dio chiqarmaslik.

Reference GET so'rovlari pending access token bilan ishlaydi. Ular candidate
type yoki pledge'ni backendga yozmaydi.

Photo va face API contractlari:

```text
ProfilePhotoRepository.uploadPhoto(profileId, file, order)
ProfilePhotoRepository.getPhotos(page)
ProfilePhotoRepository.setMainPhoto(photoId)
ProfileFaceVerificationRepository.verifySelfie(file)
```

Photo model backend structure'ini aniq nomlar bilan mirror qiladi: `id`,
`image`, `profile`, `order`, `is_main`, `created_at`, `updated_at`. Multipart,
pagination va response parsing data layer ichida qoladi.

## 9. Media service chegaralari

UI pluginlarni to'g'ridan-to'g'ri chaqirmaydi. Minimal xizmatlar:

```text
ProfilePhotoPicker
ProfileMediaProcessor
VoiceIntroRecorder
VoiceIntroPlayer
ProfilePhotoUploader
ProfileFaceVerificationService
OnboardingPrivateFileStore
```

Kutilayotgan dependencylar, implementationdan oldin compatibility tekshiruvi
bilan:

- `image_picker`
- `camera`
- `google_mlkit_face_detection`
- `image`
- `path_provider`
- `record`
- `just_audio`
- `cached_network_image`
- `flutter_image_compress` zarur bo'lsa

`google_mlkit_face_detection` uchun iOS deployment target 13.0 dan 15.5 ga
ko'tariladi. Xcode/Podfile/project settings va CI build targetlari bir xil
yangilanadi.

`permission_handler` faqat mavjud pluginlar permanently-denied va app-settings
flowini yetarli bermasa qo'shiladi.

## 10. API yozish tartibi

### Step davomida bajariladigan so'rovlar

```text
photo tanlandi -> POST /api/v1/accounts/photos/
main photo page ochildi -> GET /api/v1/accounts/photos/
main photo tanlandi -> PATCH /api/v1/accounts/photos/{id}/
selfie olindi -> POST /api/v1/accounts/face-verify/
```

Ushbu so'rovlar pending access token bilan ishlaydi. Ularning server ID va
natijalari draftga checkpoint qilinadi.

### Final submission

Bitta `FinalizeProfileOnboardingUseCase` quyidagi tasdiqlangan boshlanish bilan
orchestration qiladi:

```text
1. POST /api/v1/accounts/profiles/
2. qolgan final so'rovlar (tartibi hali berilmagan)
3. token commit
4. draft cleanup
5. Home yoki AI test navigation
```

Profile create multipart payload kamida quyidagilarni qamrab oladi:

```text
user
first_name
last_name
gender
candidate_type
birth_year
height
weight
region
district
education_level
voice_intro
```

`candidate_type` shu profile create ichida birinchi marta backendga yoziladi.
Pledge alohida POST bo'lib qoladi; uning final ketma-ketlikdagi aniq joyi hali
belgilanishi kerak.

### Backend contract konflikti

Current OpenAPI bo'yicha photo create payload `profile` UUIDni majburiy talab
qiladi. Lekin product flow suratni photo stepida, final `profiles POST`dan oldin
upload qilishni talab qilmoqda. Auth response'da `profile_info == null` bo'lsa
clientda yuboriladigan profile UUID yo'q.

Implementationdan oldin backend quyidagilardan birini tanlashi kerak:

1. Photo create `profile`ni authenticated userdan o'zi aniqlaydi va fieldni
   optional qiladi; yoki
2. draft/media profile oldin yaratiladigan alohida endpoint beradi; yoki
3. profile create photo stepidan oldinga ko'chiriladi.

Uchinchi variant hozirgi "finalda profile POST birinchi" qaroriga zid. Contract
aniqlanmaguncha photo upload integration implement qilinmaydi.

Current `ProfileRequest` yana `gender` va `weight`ni required qiladi. General
questionnaire'da weight stepi yo'q. Groom/bride candidate type'dan gender map
qilish mumkin, lekin bu backend bilan tasdiqlanadi; weight uchun yangi UI yoki
backend optional contract kerak.

Face verify OpenAPI'da request/response schema yo'q. Quyidagilar aniqlanadi:

- selfie form-data field nomi;
- main photo backendda qanday topilishi;
- match success va mismatch HTTP status/payloadlari;
- retry qilinadigan va qilinmaydigan errorlar.

### Transaction qoidalari

```text
profile POST
pledge POST (aniq joyi TBD)
token commit
draft cleanup
navigation
```

Bir nechta endpoint orasida server transaction yo'q. Client quyidagi qoida
bilan data lossni oldini oladi:

- har operation muvaffaqiyatini checkpoint sifatida draftda saqlash;
- retry'da muvaffaqiyatli operatsiyani keraksiz takrorlamaslik;
- mumkin bo'lsa idempotency key ishlatish;
- hamma majburiy operation tugamaguncha token commit va draft cleanup qilmaslik;
- partial success bo'lsa userga retry ko'rsatish.

Server endpointlar idempotent bo'lmasa checkpoint va duplicate pledge/photo
qoidasi backend bilan kelishiladi.

## 11. Routing va resume

- `status == "Anketa to'liq emas"` va PIN success: candidate type yoki draftdagi
  eng oxirgi valid step.
- Draft candidate type `representative`: vakil flowining oxirgi valid stepi.
- Draftda candidate type bor, pledge yo'q: pledge.
- Pledge bor: questionnaire `currentStep`.
- Photo stepdan keyingi resume: server GET bilan draft photo ID/URLlari
  reconcile qilinadi.
- Questionnaire tugagan, face check pending: face check.
- Final submission pending/failed: final page + retry.
- Persistent token bor: oddiy authenticated routing.
- Pending token yo'q, draft bor: login; yangi pending session olingach draft
  owner mos bo'lsa resume.
- `profile_info` mavjud yoki status complete bo'lsa onboardingga kiritmaslik.

`GET /accounts/profiles/me/` bu gate uchun hozir qo'shilmaydi; auth response'dagi
`status` va `profile_info` ishlatiladi.

## 12. Error, offline va permission holatlari

Har page uchun kerakli holatlar:

- loading;
- validation error;
- API error + retry;
- offline;
- empty reference list;
- picker cancel;
- permission denied;
- permission permanently denied + settings action;
- corrupt/unsupported media;
- file write yoki disk full;
- recorder interruption;
- camera unavailable;
- no face, multiple faces, eyes closed, poor pose;
- face mismatch + retry;
- final submission partial failure.

PII, token, local path, face verification payload/result va audio/photo URL log
qilinmaydi. Debug log faqat sanitizatsiya qilingan status/code bilan.

## 13. Accessibility va responsive talablar

- 390x844 va 390x920 Figma frame'lari bilan parity tekshiriladi.
- Kichik Android ekranlarda content scroll bo'ladi; bottom action safe area'dan
  tashqariga chiqmaydi.
- Keyboard ochilganda input va action overlap qilmaydi.
- Dynamic textda button/card text kesilmaydi.
- Chiplar wrap qiladi.
- Icon-only actionlarda tooltip/semantic label bo'ladi.
- Tap target kamida 44x44.
- Progress foizi screen reader uchun step nomi bilan beriladi.
- Barcha matn `app_uz.arb`, `app_ru.arb`, `app_en.arb`da sinxron bo'ladi.

## 14. Tavsiya etilgan fayl tuzilmasi

```text
lib/features/onboarding/
  domain/
    entities/
      profile_onboarding_draft.dart
      education_level.dart
      region.dart
      district.dart
      onboarding_photo.dart
      voice_intro.dart
      face_verification_result.dart
    repositories/
      onboarding_draft_repository.dart
      education_level_repository.dart
      location_repository.dart
      profile_photo_repository.dart
      profile_face_verification_repository.dart
    services/
      face_verification_service.dart
  application/
    use_cases/
      load_onboarding_draft.dart
      save_onboarding_draft.dart
      load_education_levels.dart
      load_regions.dart
      load_districts.dart
      upload_profile_photo.dart
      load_profile_photos.dart
      set_main_profile_photo.dart
      verify_profile_selfie.dart
      finalize_profile_onboarding.dart
  data/
    data_sources/
      onboarding_local_data_source.dart
      onboarding_reference_data_source.dart
      profile_photo_data_source.dart
      profile_face_verification_data_source.dart
    models/
      profile_onboarding_draft_model.dart
      education_level_model.dart
      region_model.dart
      district_model.dart
      profile_photo_model.dart
      profile_face_verification_model.dart
    repositories/
  presentation/
    bloc/
      profile_onboarding_bloc.dart
      profile_onboarding_event.dart
      profile_onboarding_state.dart
    pages/
      questionnaire_page.dart
      face_verification_page.dart
      onboarding_complete_page.dart
    widgets/
      onboarding_wizard_header.dart
      birth_year_step.dart
      name_step.dart
      education_step.dart
      height_step.dart
      location_step.dart
      photos_step.dart
      voice_intro_step.dart
      main_photo_step.dart
      onboarding_selection_bottom_sheet.dart
```

Bu ro'yxat ownership chegarasini ko'rsatadi; mayda class uchun keraksiz yangi
fayl ochilmaydi. Mavjud `CandidateTypePage`, `PledgePage`, `AppButton`, theme va
auth widgetlari qayta ishlatiladi.

## 15. Implementation fazalari

### Faza 1 - Auth sessionni staging qilish

- Phone, Google, Telegram token save'larini pending sessionga o'tkazish.
- Interceptorda pending token fallback.
- Final commit API.
- Provider parity va token-not-persisted testlari.

### Faza 2 - Draft va wizard skeleti

- Draft entity/model/local repository.
- Candidate type va pledge'ni API'dan uzish.
- Questionnaire Bloc, PageView, progress/header, resume.
- Existing onboarding API use case'larini DI/AuthBlocdan vaqtincha chiqarish.

### Faza 3 - Oddiy questionnaire steplari

- Birth year/date.
- Name.
- Education reference API.
- Height.
- Region/district API va custom bottom sheet.

### Faza 4 - Media

- Photo picker, private files, validation, compression va immediate multipart
  upload.
- Photo GET pagination, `CachedNetworkImage` remote rendering va PATCH main
  selection.
- AAC-LC/M4A record, preview, 30-second/1-MB limit va future playback contract.
- Android/iOS permissions va lifecycle.

### Faza 5 - Face verification

- ML Kit quality gate.
- Selfie multipart backend verification.
- Main/selfie compare UI va backend result mapping.
- Selfie cleanup.
- iOS deployment target 15.5.

### Faza 6 - Final page va API orchestration

- Photo/profile UUID, required weight/gender va face-verify schema blockerlar
  yopilgach.
- Birinchi final so'rov: multipart `POST /api/v1/accounts/profiles/`.
- Keyingi tartib tasdiqlangach pledge va boshqa qolgan operatsiyalar.
- Partial retry/checkpoint.
- Ikkala final action uchun token commit, draft cleanup va Home/test routing.

## 16. Test rejasi

### Unit

- Auth providerlar tokenni login/OTP/PIN/onboardingdan oldin persist qilmasligi.
- Pending token interceptorga berilishi.
- Commit va clear semantics.
- Draft JSON round-trip va schema migration fallback.
- Region o'zgarsa district clear.
- Har step validatsiyasi.
- Main photo invariant.
- Exact 18-60 yosh boundary va leap-year DOB.
- Photo multipart mapping va paginated GET mapper.
- Main photo PATCH mapping.
- Face verification backend result/error mapping.
- 30-second va 1-MB audio boundary.
- Finalization partial failure checkpoint.

### BLoC

- Draft load -> to'g'ri resume step.
- Invalid step oldinga o'tmaydi.
- Reference loading/success/error/empty.
- Photo/audio/face state transitionlari.
- Photo upload retry va server reconciliation.
- Double submit bloklanadi.
- Final failure token commit qilmaydi.

### Widget/golden

- Har Figma frame uchun 390 px golden.
- Small Android va large text overflow.
- Bottom sheet loading/error/empty/selected.
- Permission denied UI.
- Photo count 0, 1, 4.
- Face match success/failure.

### Integration/real device

- Phone, Google, Telegram -> PIN -> draft -> final.
- App kill: token yo'q, qayta login, draft resume.
- Camera/gallery/microphone Android va iOS.
- Background interruption.
- Offline reference retry.
- 4 photo immediate upload, GET reconcile va main PATCH.
- 30 soniyali M4A final profile upload va detail playback compatibility.
- Face verify success/mismatch/backend error.

Quality gate:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Media va camera uchun emulator test yetarli emas; kamida bitta real Android va
bitta real iOS qurilmada tekshiruv kerak.

## 17. Qarorlar va qolgan blockerlar

### Tasdiqlangan qarorlar

1. To'liq tug'ilgan sana draftda saqlanadi; hozir backendga `birth_year`
   yuboriladi.
2. Ruxsat etilgan yosh 18-60 inclusive, exact date bilan hisoblanadi.
3. Ism va familiya alohida input.
4. Bo'y 100-300 sm.
5. Surat tanlanganda darhol multipart POST; asosiy surat page'da GET; main
   tanlov PATCH orqali.
6. Remote URL uchun `CachedNetworkImage`, lokal preview uchun `Image.file`.
7. Audio AAC-LC/M4A, mono, 44.1 kHz, 64 kbps, maksimum 30 soniya va 1 MB.
8. Barcha questionnaire steplari, photo, audio va face check majburiy;
   `O'tkazib yuborish`/face `Keyinroq` olib tashlanadi.
9. Face identity match backend `POST /api/v1/accounts/face-verify/` orqali.
10. `Ha, testni boshlayman` va final `Keyinroq` ikkalasi ham muvaffaqiyatli
    finalizationdan keyin tokenni saqlaydi.
11. Final submissionning birinchi so'rovi
    `POST /api/v1/accounts/profiles/`.
12. Vakil darhol alohida 6-step vakil onboarding flowiga o'tadi.
13. iOS deployment target 15.5 ga ko'tariladi.

### Qolgan backend blockerlar

1. Photo create `profile` UUID talab qiladi, lekin photo upload profile create'dan
   oldin bo'lishi kerak. Backend contract variantlaridan biri tanlanishi shart.
2. `ProfileRequest` required `weight` uchun UI/value yo'q. Yangi step yoki
   optional backend field kerak.
3. `ProfileRequest` required `gender` candidate type'dan map qilinadimi yoki
   alohida field bo'ladimi? Groom/bride mapping backend enum bilan tasdiqlanadi.
4. Face verify OpenAPI'da selfie field nomi va response schema yo'q.
5. Yangi main photo PATCH qilinganda backend eski mainni avtomatik false
   qiladimi?
6. Photo uchun maksimal byte size, dimension va server qabul qiladigan MIME
   ro'yxati schema'da ko'rsatilmagan.
7. Profile POSTdan keyingi pledge va boshqa final so'rovlarning aniq tartibi
   hali berilmagan.
8. AI moslik testi route'i va boshlash eventi keyingi test-flow scope bilan
   beriladi.

## 18. Definition of done

- Uch auth providerda token finaldan oldin persistent storage'da yo'q.
- Candidate type va pledge API chaqirmaydi, lokal draftga yozadi.
- Questionnaire barcha berilgan Figma steplarini to'g'ri ketma-ketlikda ochadi.
- Barcha steplar majburiy; skip actionlari yo'q.
- To'liq DOB exact 18-60 yosh bilan, ism/familiya alohida va bo'y 100-300 sm
  validatsiya qilinadi.
- App qayta login qilinganda owner-matched draft resume bo'ladi.
- Education, region va filtered district reference APIlari typed model bilan
  ishlaydi.
- 4 tagacha photo darhol backendga upload bo'ladi; GET reconcile va PATCH main
  selection ishlaydi.
- Remote photo `CachedNetworkImage`, lokal preview `Image.file` orqali chiqadi.
- Majburiy AAC/M4A voice intro 30 soniya/1 MB limit bilan yoziladi va profile
  multipart requestga qo'shiladi.
- ML Kit selfie quality gate va backend face verification ishlaydi.
- Selfie tekshiruvdan keyin o'chiriladi.
- Final submission failure tokenni commit qilmaydi va draftni yo'qotmaydi.
- Final `profiles POST` birinchi bajariladi; qolgan request order tasdiqlangach
  barcha backend operatsiyalar tugaydi.
- Ikkala final actionda ham shundan so'ng token commit, draft cleanup va tegishli
  Home/AI test navigation bajariladi.
- Vakil general questionnaire'ga kirmaydi, alohida 6-step flowga o'tadi.
- iOS 15.5 targetda media/ML Kit build ishlaydi.
- L10n, accessibility, analyze, test va real-device media tekshiruvlari o'tadi.
