# Raqamli Sovchi user flow map

Source: `C:/Users/ummug/Downloads/Oqim xaritasi.png`

This document captures the app flow shown in the product flow map. Agents must
use it when changing onboarding, routing, candidate-role logic, role-specific
UI, discovery, representative workflows, psychologist services, family meeting,
or premium paywall behavior.

## Role gate

The app supports three candidate roles. The active role is determined by
`candidate_type` and can also be changed by role-selection flows.

- `kuyov`: male candidate, searches for himself.
- `kelin`: female candidate, does not initiate first writing.
- `vakil`: representative for a candidate, usually a relative such as aunt,
  uncle, or other family representative.

Role selection happens at screen `06 User turi` after splash, registration, SMS,
PIN, and biometric setup. UI and routing after this point must branch by
`candidate_type`.

## Kuyov main flow

Kuyov path:

`01 Splash` -> `02 Ro'yxatdan o'tish` -> `03 SMS kod` -> `04 PIN` ->
`05 Biometrika` -> `06 User turi` -> choose `Kuyov` -> `07 Halollik qasami` ->
`08 Tug'ilgan yil` -> `22 ... 28.1 Anketa (9 qadam)` ->
`09.1 Anketa tayyor` -> start test -> `10` -> `11` -> `12` ->
`13 So'rovnoma` -> `14 Nomzodlar`.

Secondary result:

Later action from candidate list can lead to `31 Nomzodlar - moslik yopiq`.

Kuyov UI requirements:

- Show self-candidate onboarding copy and fields.
- Allow candidate discovery after profile/questionnaire completion.
- Allow starting questionnaire/test from `09.1 Anketa tayyor`.

## Kelin flow differences

Kelin starts from the same `06 User turi` gate, then branches:

`06 User turi` -> choose `Kelin` -> same questionnaire/profile data as kuyov ->
`58 Nomzodlar` -> `60 Nomzod profili` -> accept -> `17 Suhbat ochiladi` ->
`59 So'rovlar` -> incoming intentions -> `61 Profil` ->
`62 Parda tartibi (yopiq)`.

Kelin UI requirements:

- Reuse the kuyov questionnaire where fields are the same.
- Do not present first-message initiation as the primary action.
- Prioritize incoming requests and acceptance flow.
- Photo/privacy UI must support closed veil mode.

## Vakil onboarding flow

Vakil starts from the same `06 User turi` gate, then has a 6-step onboarding:

`06 User turi` -> choose `Vakil` -> `09.a 1/6 Vakil kim?` -> continue ->
`09 2/6 Vakil ma'lumotlari` -> `09.b 3/6 Nomzod ma'lumotlari` ->
send consent request -> `51.1 4/6 Nomzod roziligi` ->
candidate confirms SMS -> `09.c 5/6 Anketa - vakil rejimi` ->
`53 6/6 Qidiruv mezonlari` -> `51 Bosh sahifa`.

Vakil UI requirements:

- Separate representative data from candidate data.
- Ask relationship to candidate before candidate profile fields.
- Consent request is a required step before daily work.
- Representative mode uses a home dashboard, not the normal candidate list as
  the first destination.

## Vakil daily work

After onboarding:

`51 Bosh sahifa` -> `52 Nomzod kartasi` -> adjust criteria ->
`53 Mezonlar` -> `54 Takliflar` -> review -> `55 So'rovni ko'rib chiqish` ->
accept and show to candidate -> `55.1 So'rov qabul qilindi` ->
`51.2 Yangi nomzod qo'shish`.

Vakil UI requirements:

- Home page must expose candidate card, criteria, offers, request review, and
  add-new-candidate actions.
- Accepted requests must be clearly separated from new/pending offers.

## Family meeting flow

Family meeting is created and accepted by representatives from both sides:

`55.1 So'rov qabul qilindi` -> kuyov representative offers meeting ->
`56 Uchrashuv belgilash` -> date/time/place -> send offer ->
`56.1 Taklif yuborildi - kutish` -> `56.2 Uchrashuv taklifi` ->
kelin representative sees it -> accept -> `56.4 Tasdiqlandi` ->
choose another time -> `56.3 -> yana 56.2` -> `56.5 Uchrashuvlar` ->
`56.7 Uchrashuv kuni` -> `56.8 Natija: davom etamizmi?`.

UI requirements:

- Meeting actions are representative-led.
- Show pending, proposed, accepted, rescheduled, meeting-day, and result states.

## Psychologist service flow

Psychologist is entered from services, not as a main tab:

`33 Profil` -> services row -> `75 Xizmatlar` -> family psychologist ->
`18 Psixologlar` -> choose psychologist -> `19 Band qilish` ->
choose time -> `19.1 To'lov` -> `19.2 Tasdiqlandi` ->
`19.3 Mening yozuvlarim` -> `16 Xabarlar` ->
psychologist chat card -> `37 Sozlamalar` -> services.

UI requirements:

- Psychologist booking belongs under services.
- Bookings, payment, confirmation, messages, and settings must stay connected.

## Premium paywall flow

Premium sells access to capabilities, not content volume:

`14 Nomzodlar` -> expanded filters -> `72` -> `15 Nomzod profili` ->
closed match sections -> `71` -> `16 Xabarlar` -> viewers info ->
`70` -> `36 Saqlangan` -> 11th profile -> `69` -> `51 Vakil` ->
2nd candidate -> `63 Premium taklifi` -> `64 Rejalar` ->
`65a Apple / 65b Payment` -> `66 Muvaffaqiyatli` ->
`67 Obunani boshqarish`.

UI requirements:

- Paywall triggers where advanced capability is requested.
- Do not frame premium as paying for profile count alone.
- Subscription management must be reachable after success.

## Auth and profile data entry point

At app entry, user data must be loaded from backend-backed auth/session flows.

Current phone login requirement:

- POST `/api/v1/accounts/auth/phone/`.
- Request body: `{ "phone_number": "+998901234567" }`.
- On success, navigate to OTP page.
- OTP page accepts temporary default code `1234` until OTP backend contract is
  connected.
- If the phone auth response includes `tokens` and `user` like Google or
  Telegram auth responses, keep them pending after the phone request. Save
  access/refresh tokens through `TokenStore` only after the user submits a valid
  OTP code.

Next profile endpoint, not active yet:

- GET `/api/v1/accounts/profiles/me/`.
- Use it after phone auth is confirmed as the next step for loading full
  profile and `candidate_type`.
- Do not call it from phone login yet.
