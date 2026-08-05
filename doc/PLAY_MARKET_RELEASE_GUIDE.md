# Play Marketga chiqarish bo'yicha ketma-ket qo'llanma

Holat sanasi: 2026-08-04

Maqsad: `Raqamli Sovchi` Flutter ilovasini Google Play Marketga xavfsiz, policyga mos va qayta chiqarishga tayyor holatda joylash.

Ushbu hujjat amaliy release tartibini beradi. Google Play talablari vaqt o'tishi bilan o'zgaradi, shuning uchun yakuniy submit qilishdan oldin Play Console ichidagi ogohlantirishlar va rasmiy policy sahifalari qayta tekshiriladi.

## 1. Eng muhim xulosa

Play Marketga chiqish uchun faqat `.aab` build yetarli emas. Quyidagi 5 yo'nalish to'liq yopilishi kerak:

1. App release konfiguratsiyasi: package name, app name, launcher icon, version, target SDK, release signing.
2. Product va policy: privacy policy, account deletion, data safety, content rating, target audience, UGC moderation.
3. App ichidagi tayyorgarlik: login, logout, delete account, report/block, permissions, crashsiz basic flow.
4. Store listing: nom, qisqa/uzun tavsif, screenshots, feature graphic, contact info.
5. Test va rollout: internal testing, closed/open testing kerak bo'lsa, production rollout.

## 2. Hozirgi loyiha bo'yicha release blokkerlar

Hozir repo holatiga qarab quyidagilar Play Marketdan oldin yopilishi kerak:

- `android/app/build.gradle.kts` ichida release build hali debug signing bilan turibdi. Bu production uchun noto'g'ri.
- `android:label` hozir `raqamli_sovchi`; Play va device ichida ko'rinadigan nom `Raqamli Sovchi` bo'lishi kerak.
- `applicationId` hozir `app.raqamlisovchi.uz.raqamli_sovchi`. Bu Play Marketga bir marta chiqqandan keyin o'zgartirish juda qiyin. Shuning uchun release oldidan final package name sifatida tasdiqlash kerak.
- `pubspec.yaml` version hozir `1.0.0+1`. Har bir upload uchun build number oshiriladi.
- Account deletion UI qo'shildi, lekin GitHub Pages uchun `doc/index.html` standart Pages source bo'lmasligi mumkin. GitHub Pages odatda root yoki `/docs` papkani oson tanlaydi. Agar `/doc` serve qilinmasa, `docs/index.html` yoki custom Pages workflow kerak.
- Ijtimoiy app bo'lgani uchun profil/photo/chat kabi user-generated content bo'lsa, report/block/moderation oqimi Play review uchun aniq ko'rsatilishi kerak.

## 3. Release oldidan branch va kod tartibi

1. Barcha releasega kiradigan ishlar `dev`dan ochilgan feature/fix branchlarda tugatiladi.
2. PR orqali `dev`ga merge qilinadi.
3. Release uchun `release/<version>` branch ochiladi.
4. Release branchda faqat release fixlar, version bump, signing/config va store tayyorgarlik o'zgarishlari bo'ladi.
5. Productionga chiqadigan kod yakunda `prod` branchga PR orqali o'tkaziladi.

Tavsiya qilingan branch:

```bash
git switch dev
git pull
git switch -c release/1.0.0
```

## 4. App identifikatorlarini final qilish

### 4.1 Package name

Tekshiriladigan joy:

```text
android/app/build.gradle.kts
```

Hozir:

```kotlin
applicationId = "app.raqamlisovchi.uz.raqamli_sovchi"
namespace = "app.raqamlisovchi.uz.raqamli_sovchi"
```

Qaror:

- Agar shu nom final bo'lsa, qoldiriladi.
- Agar yanada toza nom kerak bo'lsa, Playga birinchi uploaddan oldin o'zgartiriladi. Masalan:

```text
uz.raqamlisovchi.app
```

Muhim: Google Playda package name ilovaning doimiy identifikatori. Bir marta publish qilingandan keyin oddiy update bilan almashtirib bo'lmaydi.

### 4.2 App nomi

Tekshiriladigan joy:

```text
android/app/src/main/AndroidManifest.xml
```

Hozir:

```xml
android:label="raqamli_sovchi"
```

Release uchun:

```xml
android:label="Raqamli Sovchi"
```

Yaxshiroq variant: `android:label="@string/app_name"` qilib, `android/app/src/main/res/values/strings.xml` ichida boshqarish.

### 4.3 Launcher icon

Release oldidan default Flutter icon qolmasligi kerak.

Tekshirish:

- Android launcher icon: `android/app/src/main/res/mipmap-*`
- App ichidagi brending: splash/login sahifalaridagi iconlar
- Adaptive icon foreground/background

Tavsiya:

- `flutter_launcher_icons` ishlatish mumkin, lekin bu yangi dependency/codegen masalasi bo'lgani uchun avval arxitektura dependency siyosati bo'yicha tasdiqlanadi.
- Yoki Android Studio orqali launcher icon assetlari generate qilinadi.

## 5. Version va build number tartibi

Tekshiriladigan joy:

```text
pubspec.yaml
```

Hozir:

```yaml
version: 1.0.0+1
```

Format:

```text
versionName+versionCode
```

Misollar:

- `1.0.0+1` - birinchi internal test
- `1.0.0+2` - ikkinchi upload
- `1.0.1+3` - kichik fix

Qoida:

- Har bir Play Console upload uchun `+buildNumber` oldingisidan katta bo'lishi shart.
- Userga ko'rinadigan version `1.0.0`, Play ichidagi texnik build `+1`.

## 6. Target SDK va Android talablarini tekshirish

Google Play talabiga ko'ra 2026-08-31dan boshlab yangi app va update uchun Android 16, ya'ni API 36 yoki undan yuqori target talab qilinadi. Existing app availability uchun kamida Android 15/API 35 talablari ham bor.

Tekshiriladigan joy:

```text
android/app/build.gradle.kts
```

Hozir:

```kotlin
compileSdk = flutter.compileSdkVersion
targetSdk = flutter.targetSdkVersion
```

Amaliy tekshiruv:

```bash
flutter doctor -v
flutter --version
flutter build appbundle --release
```

Build logda Android Gradle Plugin va SDK versiyasi mosligini tekshirish kerak. Agar `targetSdk` Flutter stable SDK orqali API 36ga chiqmasa, Flutter/Android SDK toolchain update qilinadi.

## 7. Release signingni sozlash

Hozirgi blocker:

```kotlin
signingConfig = signingConfigs.getByName("debug")
```

Bu production build uchun noto'g'ri. Release uchun upload keystore kerak.

### 7.1 Upload keystore yaratish

Windows PowerShell:

```powershell
keytool -genkey -v -keystore C:\Users\<user>\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Eslatma:

- Keystore repo ichiga commit qilinmaydi.
- Parollar password managerda saqlanadi.
- Keystore yo'qolsa, key reset jarayoni murakkab bo'ladi.

### 7.2 `android/key.properties` yaratish

```properties
storePassword=<store-password>
keyPassword=<key-password>
keyAlias=upload
storeFile=C:\\Users\\<user>\\upload-keystore.jks
```

Muhim:

- `android/key.properties` `.gitignore` ichida bo'lishi kerak.
- Bu fayl hech qachon GitHubga chiqmasligi kerak.

### 7.3 Gradle release signing

`android/app/build.gradle.kts` ichida keystore properties o'qiladi va release signing `release` configga o'tkaziladi.

Release buildType yakuniy holatda shunga o'xshash bo'ladi:

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
    }
}
```

R8 release buildda odatda yoqilgan bo'ladi. Agar minify/shrink sababli runtime xato chiqsa, ProGuard rules qo'shiladi.

## 8. Release build olish

Avval sifat tekshiruvlari:

```bash
flutter clean
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Release app bundle:

```bash
flutter build appbundle --release
```

Natija:

```text
build/app/outputs/bundle/release/app-release.aab
```

Play Market uchun asosiy artifact `.aab` bo'ladi. APK faqat lokal test yoki boshqa storelar uchun kerak bo'lishi mumkin.

APK smoke test kerak bo'lsa:

```bash
flutter build apk --release --split-per-abi
```

## 9. Lokal release smoke test

Release buildni emulator va real qurilmada tekshirish kerak.

Minimal testlar:

1. App ochiladi, splash ko'rinadi.
2. Login UI buzilmagan.
3. Phone auth mock/temp flow ishlasa, OTPdan o'tadi.
4. Telegram auth button success holatda botga o'tkazadi.
5. PIN yaratish ishlaydi.
6. App Home bosilganda backgroundga ketadi va qaytganda PIN unlock chiqadi.
7. Biometric prompt avtomatik chiqadi, cancel bosilsa PIN fallback ishlaydi.
8. Logout ishlaydi.
9. Delete account dialog chiqadi va confirmdan keyin user session tozalanadi.
10. Internet yo'q holatda error UI tushunarli.
11. Rotation/font scale/basic accessibility buzmaydi.
12. Release buildda PII/token log chiqmaydi.

## 10. Privacy policy tayyorlash

Play Console uchun privacy policy URL kerak bo'ladi, ayniqsa app user data yig'sa.

Privacy policy sahifasida kamida quyidagilar bo'lishi kerak:

- App nomi va developer nomi.
- Qanday data yig'iladi: telefon raqam, account ma'lumotlari, profil ma'lumotlari, rasmlar, chat/media bo'lsa, device/session ma'lumotlari.
- Nima uchun yig'iladi: auth, matchmaking, moderation, support, security.
- Data kimlar bilan ulashiladi: backend service, analytics/crash service bo'lsa, ular.
- Data qancha saqlanadi.
- User qanday delete account qiladi.
- Support email.
- Policy oxirgi yangilangan sana.

Tavsiya URL:

```text
https://raqamlisovchi.uz/privacy
```

GitHub Pages vaqtinchalik ishlatilishi mumkin, lekin production uchun domain ostidagi URL yaxshiroq.

## 11. Account deletion talabi

Agar app account yaratishga ruxsat bersa, Google Play account deletion uchun ikki yo'lni kutadi:

1. App ichida account deletion request yoki deletion action.
2. Web link orqali account deletion request.

Bu loyihada app ichida Delete account UI qo'shildi. Web sahifa uchun hozir:

```text
doc/index.html
```

### 11.1 GitHub Pages masalasi

GitHub Pages standart sozlamalarida odatda quyidagi source variantlar bor:

- root `/`
- `/docs`
- GitHub Actions custom workflow

Bizdagi fayl:

```text
doc/index.html
```

Agar Pages UI `/doc`ni source sifatida bermasa, quyidagidan biri qilinadi:

Variant A - tavsiya:

```text
docs/index.html
```

Variant B:

```text
doc/index.html`ni custom GitHub Actions Pages workflow bilan publish qilish.
```

Variant C:

```text
raqamlisovchi.uz/account-deletion sahifasiga deploy qilish.
```

### 11.2 Web deletion sahifasida bo'lishi kerak

- App nomi.
- Account o'chirish ketma-ketligi.
- Appga kira olmagan user uchun support email yoki request form.
- Qaysi ma'lumotlar o'chiriladi.
- Qaysi ma'lumotlar qonuniy, xavfsizlik yoki audit sababi bilan vaqtincha saqlanishi mumkin.
- Deletion processing vaqti.
- Contact email.

## 12. Data Safety form tayyorlash

Play Console ichida `Policy > App content > Data safety` to'ldiriladi.

Bu app uchun ehtimoliy data kategoriyalari:

- Personal info: phone number, name, age, gender/marital/profile fields bo'lsa.
- Photos and videos: profile photos, chat media bo'lsa.
- Messages: chat bo'lsa.
- App activity: auth/session/security/moderation events bo'lsa.
- Device or other IDs: push token, app-scoped device id bo'lsa.
- Location: agar location feature qo'shilsa.

Har bir data turi uchun aniq belgilanadi:

- Collected?
- Shared?
- Required or optional?
- Purpose: app functionality, account management, security, fraud prevention, analytics, developer communications.
- Encrypted in transit?
- User can request deletion?

Muhim: Data Safety form privacy policy va app real xatti-harakatiga mos bo'lishi kerak. App aslida yig'adigan data yashirilmaydi, yig'maydigan data esa ortiqcha belgilanmaydi.

## 13. User-generated content va moderation

Raqamli Sovchi ijtimoiy app bo'lgani uchun UGC ehtimoli yuqori:

- Profil matni.
- Profil rasmlari.
- Chat xabarlari.
- Media attachmentlar.

Google Play review uchun quyidagilar tayyor bo'lishi kerak:

1. Userni report qilish.
2. Userni block qilish.
3. Objectionable contentni report qilish.
4. Terms/Community Guidelines.
5. Backend moderation yoki admin review jarayoni.
6. Account/profile/photo olib tashlash mexanizmi.

App birinchi releasega chat/media bilan chiqmasa ham, profil photo yoki user profile mavjud bo'lsa moderation masalasi ochiq qoladi.

Minimal release blocker:

- `Report user`
- `Block user`
- `Terms and Community Guidelines` linklari
- Admin/moderator uchun reportlarni ko'rish yo'li

## 14. Permissions audit

Hozir manifestda:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

Tekshiriladi:

- Har bir permission appdagi real featurega bog'langanmi?
- Permission so'ralishidan oldin userga sabab tushuntiriladimi?
- User rad etsa app crash qilmaydimi?
- Camera/microphone/location qo'shilsa, privacy policy va Data Safety yangilanadimi?

Qoida:

- Keraksiz permission qo'shilmaydi.
- Sensitive permissionlar faqat kerak bo'lgan vaqtda so'raladi.
- Background location, contacts, SMS, call log kabi yuqori risk permissionlardan qochiladi.

## 15. Play Console account tayyorlash

Kerak bo'ladiganlar:

- Google Play Developer account.
- Developer profile: legal name, address, email.
- Payment profile kerak bo'lsa.
- Contact email.
- Website.
- Privacy policy URL.
- App access instructions.

App access instructions muhim:

- Agar reviewer login qilishi kerak bo'lsa, test account beriladi.
- OTP/Telegram/PIN flow qanday ishlashi yoziladi.
- Agar OTP backend hali real bo'lmasa, productionga chiqishdan oldin real test user yoki review bypass bo'lmasligi kerak. Play review uchun ishlaydigan auth yo'li bo'lishi shart.

## 16. Store listing tayyorlash

Kerakli materiallar:

- App name: `Raqamli Sovchi`
- Short description.
- Full description.
- App icon: 512x512 PNG.
- Feature graphic: 1024x500 PNG.
- Phone screenshots: kamida 2 ta, tavsiya 6-8 ta.
- Tablet screenshots: agar tablet support qilinsa.
- Category: ehtimol `Dating` yoki `Social`, Play Console variantlariga qarab tanlanadi.
- Tags.
- Contact email.
- Website.
- Privacy policy URL.

Screenshotlar:

- Real UI release builddan olinadi.
- Fake data ishlatiladi.
- Private phone number/token/chat ko'rinmaydi.
- Uzbek tilidagi asosiy flowlar ko'rsatiladi: login, OTP, PIN, profile/home.

## 17. App content formalar

Play Console ichida quyidagilar to'ldiriladi:

1. Privacy policy.
2. App access.
3. Ads: appda reklama bormi yoki yo'q.
4. Content rating questionnaire.
5. Target audience and content.
6. News apps: yo'q bo'lsa belgilanadi.
7. COVID/contact tracing kabi maxsus kategoriyalar: yo'q bo'lsa belgilanadi.
8. Data safety.
9. Government apps yoki financial features bo'lsa mos formalar.

Raqamli Sovchi uchun alohida e'tibor:

- Dating/social kategoriya policylari.
- 18+ target audience masalasi.
- UGC moderation.
- Account deletion.
- Privacy policy va Data Safety mosligi.

## 18. Internal testing release

Productiondan oldin birinchi `.aab` internal testing trackka yuklanadi.

Ketma-ketlik:

1. Play Console > Create app.
2. App details va store listing minimal to'ldiriladi.
3. App content formalar to'ldiriladi.
4. Internal testing track yaratiladi.
5. Tester email list qo'shiladi.
6. `app-release.aab` upload qilinadi.
7. Release notes yoziladi.
8. Reviewga yuboriladi.
9. Testerlar install qilib smoke test qiladi.

Internal testingda ham Data Safety form kerak bo'lishi mumkin, shuning uchun "productionga keyin to'ldiramiz" deb qoldirmaslik kerak.

## 19. Closed testing va production rollout

Yangi developer accountlarda Google Play qo'shimcha closed testing talablarini qo'yishi mumkin. Play Console nima talab qilsa, shu bajariladi.

Umumiy tartib:

1. Internal testing passed.
2. Closed testing kerak bo'lsa, testerlar bilan kamida kerakli muddat sinov qilinadi.
3. Crash, ANR, auth, deletion, moderation muammolari tuzatiladi.
4. Production release yaratiladi.
5. Staged rollout bilan boshlanadi: 5% yoki 10%.
6. Crash/ANR/policy feedback kuzatiladi.
7. Muammo bo'lmasa 100% rollout.

## 20. Release oldi texnik checklist

Har release oldidan:

- [ ] `flutter doctor -v` sog'lom.
- [ ] `flutter pub get` o'tadi.
- [ ] `dart format --set-exit-if-changed .` o'tadi.
- [ ] `flutter analyze` o'tadi.
- [ ] `flutter test` o'tadi.
- [ ] `flutter build appbundle --release` o'tadi.
- [ ] Release signing debug key emas.
- [ ] `versionCode` oldingi uploaddan katta.
- [ ] App icon final.
- [ ] App label final.
- [ ] Package name final.
- [ ] Backend base URL production.
- [ ] Debug banner yo'q.
- [ ] Release buildda request/response log PII chiqarmaydi.
- [ ] Screenshot protection talab qilingan ekranlarda yoqilgan.
- [ ] Account deletion app ichida ishlaydi.
- [ ] Account deletion web URL ishlaydi.
- [ ] Privacy policy URL ishlaydi.
- [ ] Terms/Community Guidelines URL ishlaydi.
- [ ] Report/block flow ishlaydi.
- [ ] App reviewer uchun login instructions tayyor.

## 21. Release oldi product checklist

- [ ] App nomi: `Raqamli Sovchi`.
- [ ] Short description tayyor.
- [ ] Full description tayyor.
- [ ] Screenshots tayyor.
- [ ] Feature graphic tayyor.
- [ ] 512x512 icon tayyor.
- [ ] Support email ishlaydi.
- [ ] Website ishlaydi.
- [ ] Privacy policy ishlaydi.
- [ ] Account deletion sahifasi ishlaydi.
- [ ] Test account yoki reviewer instructions tayyor.
- [ ] Data Safety javoblari real appga mos.
- [ ] Content rating savollari to'g'ri javoblangan.
- [ ] Target audience to'g'ri tanlangan.
- [ ] Ads bor/yo'qligi to'g'ri ko'rsatilgan.

## 22. Tavsiya qilingan release tartibi

1. `dev` branchni tozalash: analyzer/test/build.
2. Release blockerlarni yopish: signing, app label, icon, package final decision.
3. Account deletion web sahifasini deploy qilish.
4. Privacy policy va Terms sahifalarini tayyorlash.
5. UGC moderation minimal flowlarini qo'shish: report/block.
6. Production backend configni tekshirish.
7. `version: 1.0.0+1` final qilish yoki build numberni oshirish.
8. `release/1.0.0` branch ochish.
9. Release `.aab` build olish.
10. Real qurilmada smoke test.
11. Play Console app yaratish.
12. Store listing va App content formalarni to'ldirish.
13. Internal testingga upload.
14. Tester feedback va Play warninglarni tuzatish.
15. Closed testing kerak bo'lsa o'tkazish.
16. Production staged rollout.
17. Crash/ANR/review feedback monitoring.

## 23. Reviewer uchun App access instructions namunasi

Play Console > App content > App access ichida shunga o'xshash yoziladi:

```text
This app requires sign-in.

Primary sign-in method:
1. Open the app.
2. Tap Telegram or phone sign-in.
3. Complete authentication.
4. Create a 4-digit local PIN.
5. Use the app.

Account deletion:
1. Sign in.
2. Open Home/Settings.
3. Tap Delete account.
4. Confirm deletion.

If reviewer access requires a test account, use:
Phone: <test-phone>
OTP: <test-otp>
```

Muhim: Production reviewda ishlamaydigan mock OTP yoki backendda yo'q flow qoldirilmaydi. Reviewer appga kira olmasa, app reject bo'lishi mumkin.

## 24. Manbalar

- Flutter Android release guide: https://docs.flutter.dev/deployment/android
- Google Play target API level requirement: https://developer.android.com/google/play/requirements/target-sdk
- Android privacy checklist: https://developer.android.com/privacy-and-security/about
- Google Play account deletion requirement: https://support.google.com/googleplay/android-developer/answer/13327111
- Google Play Data safety form: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play UGC policy: https://support.google.com/googleplay/android-developer/answer/9876937
