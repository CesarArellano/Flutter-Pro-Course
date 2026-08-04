You are an expert in Dart, Flutter, and scalable mobile application development. You write
idiomatic, maintainable, performant, and accessible code following current Flutter and Dart best
practices.

> Verified against this repo (2026-08-03): Flutter 3.44.4 (stable) / Dart 3.12.2, `flutter_riverpod`
> ^2.3.6 (StateNotifier-based, no code generation), `go_router` ^17.3.0 (declarative, path-param
> based), `dio` ^5.11.0 behind a hand-rolled `NetworkService`, `drift` ^2.34.3 for local persistence,
> `cached_network_image` ^3.4.1 behind a hand-rolled `AppNetworkImage` widget, `flutter_dotenv` for
> secrets, `flutter_lints` ^6.0.0 plus a curated set of extra lints in `analysis_options.yaml`. No
> `freezed`/`json_serializable`/riverpod code generation anywhere in this repo — JSON models are
> hand-written. Only one test file exists (`test/widget_test.dart`, the default counter-app
> scaffold, not a real test) — treat "Testing" below as the convention to adopt going forward, not
> an established pattern to match.

## Project overview

clappy — a movie browser app (now playing / popular / top rated / upcoming, movie detail,
search, favorites) backed by The Movie DB API, with offline favorites persisted locally via Drift.

## Commands

- `flutter pub get` — install dependencies.
- `flutter run` — run on a connected device/simulator.
- `flutter analyze` — static analysis (must be clean before considering work done).
- `dart format .` — format (note `require_trailing_commas`/`eol_at_end_of_file` are enforced lints).
- `flutter test` — run the test suite. `flutter test test/some_test.dart` for a single file.
- `dart run build_runner build` — regenerate Drift's `app_database.g.dart` after changing
  `lib/infrastructure/datasources/drift/app_database.dart` (per README.md). Use `build_runner watch`
  during active schema iteration, `build` for a one-shot regenerate.
- Copy `.env.template` → `.env` and set `THE_MOVIEDB_KEY` before first run — `Environment` (
  `lib/config/constants/environment.dart`) reads it via `flutter_dotenv`; `.env` is declared as a
  Flutter asset in `pubspec.yaml`, not read from the OS environment.
- No CI config, melos/monorepo tooling, or `flutter_launcher_icons`/`flutter_native_splash` regen
  script beyond their normal `dart run flutter_launcher_icons`/`dart run flutter_native_splash:create`
  — only run those when icons/splash assets actually change.

## Architecture / Folder Structure

Clean-Architecture-flavored layering under `lib/`, confirmed by the current tree — **do not**
introduce the generic `data/`+`ui/` MVVM split described by the `flutter-apply-architecture-best-
practices` skill; this repo has already committed to the structure below:

- **`config/`** — cross-cutting, non-feature app setup: `router/` (go_router config),
  `theme/`, `network/` (`NetworkService`, interceptors, `NetworkException`), `constants/`
  (`Environment`), `extensions/`, `helpers/`. Nothing feature-specific lives here.
- **`domain/`** — the pure, framework-agnostic core: `entities/` (plain Dart classes with no JSON
  or Drift knowledge, e.g. `Movie`, `Actor`, `Video`), `repositories/` (abstract contracts, e.g.
  `MoviesRepository`), `datasources/` (abstract contracts, e.g. `MoviesDatasource`,
  `LocalStorageDatasource`). Nothing under `domain/` imports Dio, Drift, or Flutter widgets.
- **`infrastructure/`** — concrete implementations of the `domain/` contracts: `datasources/`
  (`MovieDbDatasource` implements `MoviesDatasource` over `NetworkService`; `DriftDatasource`
  implements `LocalStorageDatasource` over the generated `AppDatabase`), `models/moviedb/` (raw
  API JSON models, one file per TMDB response shape), `mappers/` (static classes translating
  API/DB models → domain entities, e.g. `MovieMapper.movieDBToEntity`), `repositories/`
  (`MoviesRepositoryImpl` — thin pass-through to a datasource; add real orchestration/caching here
  only when a feature actually needs it, don't pre-build it).
- **`presentation/`** — everything Flutter-aware: `screens/` (routed, top-level pages),
  `views/` (composed sections within a screen, e.g. tabs), `widgets/` (grouped by feature —
  `movies/`, `videos/`, `shared/`), `delegates/` (e.g. `SearchMovieDelegate`), `providers/`
  (Riverpod, grouped by feature — `movies/`, `network/`, `search/`, `storage/`).
- Each grouping directory (`domain/entities/`, `presentation/screens/`, `presentation/widgets/`,
  `presentation/views/`) has a barrel file (`entities.dart`, `screens.dart`, `widgets.dart`,
  `views.dart`) re-exporting its siblings — new files in those directories get added to the
  matching barrel, and other code imports the barrel rather than the individual file.
- One concept per file. Datasource → mapper → entity is a strict one-way pipeline: mappers only
  ever appear inside `infrastructure/`, never inside `presentation/`.

## Flutter & Dart Best Practices

- Prefer `const` constructors wherever the lint (`prefer_const_constructors`, on via
  `flutter_lints`) allows.
- `sort_constructors_first` and `prefer_final_fields`/`prefer_final_locals`/
  `prefer_final_in_for_each` are enforced project lints — write constructors first in a class body
  and default to `final` everywhere a value isn't reassigned.
- `type_annotate_public_apis` and `always_declare_return_types` are enforced — don't rely on
  inference for public members.
- `require_trailing_commas` is enforced — matches `dart format`'s multi-line output; don't fight it.
- Use switch **expressions** (`switch (x) { A => ..., B => ... }`) and pattern matching over
  chained `if`/`else` where the value is a closed set (enum, sealed class) — see the
  `dart-use-pattern-matching` skill.
- Use `dart-use-primary-constructors` where a class is a straightforward constructor-then-fields
  shape.

### Extensions

`lib/config/extensions/` holds null-coalescing helpers (`null_extensions.dart`) consumed across
`presentation/`. Extensions are also this repo's lightweight substitute for the classic Strategy
pattern — attach per-type/per-variant behavior directly to a value instead of writing a
`getColorForX(value)`-style free function or a full interface + implementations when nothing needs
runtime swapping. See the **`dart-use-extensions-for-strategy`** skill for when this applies vs.
sealed-class pattern matching vs. a real interface-based Strategy (e.g. `NetworkService` itself,
which *is* injected and needs to stay swappable/mockable).

### State management (Riverpod)

- This repo uses **`flutter_riverpod` without code generation** — providers are hand-declared
  top-level `final` variables (`Provider`, `StateNotifierProvider`), grouped per feature under
  `presentation/providers/<feature>/`. Don't introduce `riverpod_generator`/`@riverpod` annotations
  without an explicit decision to migrate the whole provider layer — mixing styles is worse than
  either alone.
- Pattern already established: a `Provider<Repository>` wraps a datasource, a
  `StateNotifierProvider<XNotifier, State>` watches that repository and exposes UI state, and the
  `XNotifier` takes the needed repository method as an injected callback (`fetchMoreMovies`) rather
  than the whole repository — keep following this for new list-like providers (see
  `movies_providers.dart`).
- `ref.watch` inside a provider body to react to upstream changes; `ref.read` inside notifier
  methods/callbacks. Don't call `ref.watch` outside a provider/widget `build`.

### Routing (go_router)

- Declarative route tree in `lib/config/router/app_router.dart`, nested `GoRoute`s with named
  routes for anything pushed via `context.pushNamed`/`goNamed` (e.g. `MovieScreen.name`).
  Path params come through `state.pathParameters` — always guard the missing case with `??`
  (existing routes default to `'0'`/`'no-id'`) rather than assuming the param is present.
  See `flutter-setup-declarative-routing` for adding shell routes/nested navigators if a bottom
  nav or tabbed shell is introduced (currently commented-out scaffolding exists for this in
  `app_router.dart` — read it before reintroducing a `ShellRoute`).

### Networking (Dio)

`NetworkService` (`lib/config/network/network_service.dart`) is the only class that touches `Dio`
directly — see **`flutter-build-network-service-layer`** for how it's put together (interceptor
order, retry policy, error mapping) and **`flutter-use-dio-client`** for how to call it correctly
from a datasource. In short: datasources depend on `NetworkService`, never on `Dio`; errors surface
as `NetworkException`, never as raw `DioException`.

### Local persistence (Drift)

- `DriftDatasource` implements `LocalStorageDatasource` over a generated `AppDatabase`
  (`infrastructure/datasources/drift/app_database.dart` + its generated `.g.dart`). Favorites are
  the only persisted entity today.
- After editing table definitions, run `dart run build_runner build` — never hand-edit
  `app_database.g.dart`.
- List-typed columns (`genreIds`) are stored as a joined string (`_encodeGenreIds`/
  `_decodeGenreIds`) since Drift columns are scalar — follow this convention for any new
  list-of-primitives column rather than introducing a JSON column ad hoc.

### Images

Every network image goes through `AppNetworkImage`
(`lib/presentation/widgets/shared/app_network_image.dart`), never a bare `Image.network` or
`FadeInImage`+`NetworkImage` — it wraps `cached_network_image` with this app's standard
placeholder (a `black12` box), error state (a `broken_image_outlined` icon), and fade-in, and caps
decode resolution to what's actually rendered via `cacheDimension`
(`lib/config/helpers/image_cache_dimensions.dart`, a `logicalSize * devicePixelRatio` helper) so a
150dp poster tile doesn't decode a full TMDB `w500` image.

- Pass `width`/`height` as normal — `AppNetworkImage` uses them for both layout and cache sizing.
- If the actual layout width/height is `double.infinity` (filling an already-sized parent, e.g. a
  card `Container(width: 150, ...)`), pass the real target size via `cacheWidth`/`cacheHeight`
  instead — an infinite value can't be used to compute a cache size (see the `_CastCard`/
  `_CreditCard` usages in `movie_screen.dart`/`person_movie_credits.dart` for the pattern).
- The two "no image available" fallback URLs (poster/backdrop vs. profile photo) live in
  `ImagePlaceholders` (`lib/config/constants/image_placeholders.dart`) — reference those constants
  from a mapper rather than inlining the URL string again.

### JSON / API models

Hand-written model classes under `infrastructure/models/moviedb/`, one per TMDB response shape,
each with a `fromJson` factory — no `json_serializable`/`freezed` codegen in this repo. Keep new
API models consistent with this hand-written style, and route every model → entity conversion
through a static `Mapper` class in `infrastructure/mappers/` (see `MovieMapper`) rather than
putting a `toEntity()` method on the model itself — that keeps `infrastructure/models/` a pure
mirror of the API contract. See `flutter-implement-json-serialization` if a new response shape
needs deeper nesting/enum handling than the existing models use.

### Testing

Not yet established beyond the default scaffold — when adding real tests:

- Unit-test mappers and repositories in isolation; mock `NetworkService`/datasources rather than
  hitting the real API (`dart-generate-test-mocks`).
- Widget-test `presentation/widgets/` and `views/` per `flutter-add-widget-test`.
- See `dart-add-unit-test`, `flutter-add-integration-test`, and `dart-collect-coverage` for
  scaffolding a coverage report once a real suite exists — there's no coverage baseline to protect
  yet, so don't block on a coverage threshold that isn't configured anywhere.

## Available Skills

Project skills live in `.claude/skills/` (symlinked from `.agents/skills/`, which is kept in sync
via `skills-lock.json` from `flutter/agent-plugins` — don't hand-edit files under `.agents/skills/`,
they'll be overwritten on next sync; the three project-specific skills below live only under
`.claude/skills/`). Invoke the relevant one instead of re-deriving the workflow inline:

| Topic | Skill |
|---|---|
| Networking / Dio wrapper design | `flutter-build-network-service-layer` |
| Calling the network layer from a datasource | `flutter-use-dio-client` |
| Extension methods as a Strategy substitute | `dart-use-extensions-for-strategy` |
| Overall layering (read the caveat above first) | `flutter-apply-architecture-best-practices` |
| Declarative routing / shell routes | `flutter-setup-declarative-routing` |
| JSON model shapes | `flutter-implement-json-serialization` |
| Switch expressions / sealed classes | `dart-use-pattern-matching` |
| Constructor-first class shape | `dart-use-primary-constructors` |
| Responsive layout | `flutter-build-responsive-layout` |
| Diagnosing a layout overflow/constraint error | `flutter-fix-layout-issues` |
| Diagnosing a runtime exception | `dart-fix-runtime-errors` |
| Widget preview | `flutter-add-widget-preview` |
| Unit tests | `dart-add-unit-test` |
| Widget tests | `flutter-add-widget-test` |
| Integration tests | `flutter-add-integration-test` |
| Generating mocks for tests | `dart-generate-test-mocks` |
| Coverage reports | `dart-collect-coverage` |
| Static analysis | `dart-run-static-analysis` |
| Package version conflicts | `dart-resolve-package-conflicts` |
| Localization | `flutter-setup-localization` |
| FFI (native interop) | `dart-use-ffigen`, `dart-setup-ffi-assets` |
| Dart CLI tooling | `dart-build-cli-app` |
| Migrating assertions to `package:checks` | `dart-migrate-to-checks-package` |

## Do not

- Don't introduce the generic `data/`+`domain/`+`ui/` MVVM folder split from
  `flutter-apply-architecture-best-practices` — this repo uses `config/`+`domain/`+
  `infrastructure/`+`presentation/`; follow that instead.
- Don't instantiate a second `Dio()` anywhere outside `network_service.dart` — see
  `flutter-build-network-service-layer`/`flutter-use-dio-client`.
- Don't catch `DioException` at a call site — catch the mapped `NetworkException`.
- Don't add `riverpod_generator`/`@riverpod` annotated providers alongside the existing
  hand-declared providers without an explicit decision to migrate the whole layer.
- Don't hand-edit `app_database.g.dart` — regenerate it with `build_runner`.
- Don't put a `toEntity()`/mapping method directly on an `infrastructure/models/` class — mapping
  belongs in `infrastructure/mappers/`.
- Don't add a duplicate extension member for something that already exists in
  `lib/config/extensions/` (e.g. two near-identical `firstOrNull` getters) — consolidate instead.
- Don't use a bare `Image.network`/`FadeInImage`+`NetworkImage` — use `AppNetworkImage` so caching,
  resolution-capping, and the placeholder/error treatment stay consistent app-wide.
- Don't inline the "no image available" placeholder URLs again — use `ImagePlaceholders`.
- Don't retry non-idempotent HTTP methods or blanket-retry 4xx responses in any interceptor.
- Don't log request/response bodies outside `kDebugMode`.
- Don't skip the `.env` setup step and hardcode `THE_MOVIEDB_KEY` inline as a workaround.
