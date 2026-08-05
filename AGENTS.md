# Agent Instructions

This project is a new Flutter social application. Before making any code,
architecture, UI, dependency, security, or testing change, read and follow:

- `doc/ARCHITECTURE_TECHNICAL_SPEC.md`

For product context and privacy expectations for the Raqamli Sovchi mobile app,
also read:

- `doc/PRIVACY_POLICY.md`

The architecture spec is the source of truth for this repository. Do not copy
architecture rules into other files unless the user explicitly asks for a
summary. If another project document and the architecture spec conflict, follow
the architecture spec and report the conflict.

Before making any Git, branch, commit, push, pull request, merge, release, or
repository protection change, read and follow:

- `doc/GIT_WORKFLOW.md`

That file is the source of truth for this repository's Git workflow. Do not push
directly to `dev`, `prod`, or `main`. Use feature/fix/chore branches and pull
requests according to the documented promotion path.

## Project Skills

Project-specific skills live under `.agents/skills/`. Use them when the task
matches their purpose:

- `$flutter-feature-builder`: create or extend feature folders, BLoC/Cubit,
  domain/application/data/presentation files, widgets, and tests.
- `$architecture-guard`: review code changes against the architecture,
  security, UI organization, and testing rules.
- `$api-client-builder`: add Dio API integrations, data sources, repositories,
  DTO models, mappers, typed failures, and network tests.
- `$git-workflow-guard`: handle Git, branch, PR, merge, release, collaborator,
  and repository protection work according to `doc/GIT_WORKFLOW.md`.

## Core Rules

- Use Clean Architecture with a feature-first structure.
- Keep dependency direction strict: `presentation -> application -> domain <- data`.
- Do not import Flutter, BLoC, Dio, Firebase, WebSocket, storage, or platform
  packages into the domain layer.
- Use `flutter_bloc` for presentation state.
- Use `Bloc<Event, State>` for complex flows and `Cubit<State>` for simple view
  state.
- Keep BLoC/Cubit, event, and state in separate files for non-trivial features.
- Use `get_it` for dependency injection with manual registration.
- Use `dio` for HTTP and map API results to typed `Either<Failure, T>` or
  `Result<T>` values.
- Do not let raw exceptions such as `DioException` reach UI or BLoC layers.
- Use immutable Dart classes with `Equatable` for entities, models, events, and
  states.
- Avoid code generation by default. Reconsider generators only when the
  architecture spec allows it.

## UI and File Organization

- Keep pages/screens lean. Extract reusable or large UI parts into separate
  widget files.
- Do not place full screen UI and many widget classes in one file.
- Put feature widgets under `features/<feature>/presentation/widgets/`.
- Put shared widgets under `core/ui/widgets/`.
- Build and reuse design-system widgets such as `AppTextField`, `AppButton`,
  `AppAvatar`, `AppErrorView`, and `AppEmptyState`.
- Do not hardcode colors, typography, spacing, or radius inside feature UI.
- All user-facing text must come from generated l10n resources in
  `lib/l10n/*.arb`; do not add hardcoded UI copy in pages, widgets, dialogs,
  snackbars, tooltips, semantic labels, empty states, or error states.
- Keep English (`app_en.arb`), Russian (`app_ru.arb`), and Uzbek
  (`app_uz.arb`) translations in sync whenever UI text is added or changed.
- The default app locale is Uzbek (`uz`) until an explicit in-app language
  setting is implemented.
- Every screen must handle loading, empty, error, offline, and permission-denied
  states where applicable.

## Security and Privacy

- Treat screenshot protection as a product requirement, especially for chat,
  profile, and media screens.
- Store access tokens, refresh tokens, session secrets, and sensitive runtime
  values only in secure storage.
- Never store API secrets, admin keys, service account keys, or private signing
  keys inside the mobile app.
- Environment config may contain `baseURL`, WebSocket URL, flavor, and feature
  flags, but these values are not secrets.
- Do not log PII, tokens, chat content, media URLs, or private user data.
- FCM token lifecycle must be handled through secure local storage and backend
  user-device registration.

## Chat and Media

- Realtime chat must use a transport abstraction; BLoC must not import WebSocket
  packages directly.
- Chat messages must support optimistic sending, server acknowledgement,
  idempotency keys, retry, and explicit message status.
- Voice notes and circular videos must use separate media services for
  recording, playback, validation, compression, upload, retry, and cancellation.
- Media uploads must validate MIME type, size, extension, duration, and remove
  sensitive metadata before upload when possible.

## Testing and Quality Gates

- Add focused tests for risky behavior, BLoC state transitions, repositories,
  mappers, and use cases.
- Use `bloc_test` and `mocktail` for BLoC and dependency tests.
- Before finishing code changes, run the relevant checks when feasible:
  - `flutter analyze`
  - `dart format --set-exit-if-changed .`
  - relevant unit/widget/BLoC tests
- If checks cannot be run, clearly state why.

## Change Discipline

- Prefer existing project patterns over new abstractions.
- Keep changes scoped to the requested feature or fix.
- Do not refactor unrelated code.
- For repository changes, work from `dev` on a scoped branch such as
  `feature/*`, `fix/*`, or `chore/*`; merge only through PR.
- Do not add a dependency without checking the dependency policy in
  `doc/ARCHITECTURE_TECHNICAL_SPEC.md`.
- If the user requests something that conflicts with the architecture spec,
  explain the tradeoff and suggest the safer alternative before implementing.
