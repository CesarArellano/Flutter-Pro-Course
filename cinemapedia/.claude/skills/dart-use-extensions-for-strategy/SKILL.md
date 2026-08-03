---
name: dart-use-extensions-for-strategy
description: Use Dart extension methods to implement per-type/per-variant behavior (a lightweight Strategy pattern) instead of scattering if-else or switch chains across the codebase, or reaching for a classic interface-based Strategy when it isn't needed.
---

# Extension Methods as a Lightweight Strategy Pattern

## Contents
- [When This Applies](#when-this-applies)
- [Extension-as-Strategy vs. the Alternatives](#extension-as-strategy-vs-the-alternatives)
- [Workflow: Writing a Strategy Extension](#workflow-writing-a-strategy-extension)
- [Examples](#examples)
- [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

## When This Applies

Classic OOP Strategy needs an interface, one class per variant, and a context that holds a reference to the current strategy. That's overkill when the "strategy" is really just a pure, stateless function of a value that already exists in the codebase — an `enum`, a model, a primitive. Dart extension methods let you attach that behavior directly to the type without subclassing or DI wiring.

Reach for this when:
- The behavior varies by *type* or *enum variant*, not by *runtime configuration* (nothing needs to swap the strategy at runtime or mock it in a test).
- You keep writing the same `if (x is Foo) ... else if (x is Bar) ...` or `switch` on a value's shape in more than one place.
- The logic is presentation/formatting/derivation, not business logic that owns state or side effects.

## Extension-as-Strategy vs. the Alternatives

| Need | Use |
|---|---|
| Pure, stateless behavior keyed off an existing type/enum, called from many places | **Extension method** (this skill) |
| A closed set of variants where the compiler must catch a missing case when a new variant is added | Sealed class + exhaustive `switch` — see `dart-use-pattern-matching` |
| The behavior must be swappable at runtime, injected via constructor, or mocked in unit tests (e.g. a datasource, a payment processor) | Classic interface-based Strategy (abstract class + implementations + constructor injection) — e.g. this repo's `NetworkService` injected into `MovieDbDatasource`, or the `Interceptor` chain in `network_service.dart` |
| Behavior has internal state or lifecycle | A regular class, not an extension |

Extensions and the other two aren't mutually exclusive — an extension can internally use a `switch` on a sealed type for exhaustiveness, it just skips the interface/DI ceremony at the call site.

## Workflow: Writing a Strategy Extension

- [ ] 1. Confirm the behavior is a pure function of the receiver (no captured mutable state, no side effects beyond simple formatting).
- [ ] 2. Name the extension for the *capability*, not the type (`MovieRatingDisplay on Movie`, not `MovieExtension on Movie`) — multiple small, purpose-named extensions on the same type are fine and preferred over one large grab-bag extension.
- [ ] 3. If dispatching on an `enum` or `sealed class`, use a `switch` expression inside the extension getter/method so the compiler flags missing variants (see `dart-use-pattern-matching`).
- [ ] 4. Put each extension in its own file under `lib/config/extensions/`, named after the capability (`movie_rating_display.dart`), not a shared dumping-ground file.
- [ ] 5. Never shadow a real member name (don't extend `List` with a method also called `first`) — pick a distinct name so autocomplete and call sites stay unambiguous.

## Examples

### Strategy via extension on an enum

```dart
enum MovieVoteTier { excellent, good, average, poor }

extension MovieVoteTierFromScore on double {
  MovieVoteTier get voteTier => switch (this) {
    >= 8.0 => MovieVoteTier.excellent,
    >= 6.0 => MovieVoteTier.good,
    >= 4.0 => MovieVoteTier.average,
    _ => MovieVoteTier.poor,
  };
}

extension MovieVoteTierPresentation on MovieVoteTier {
  Color get badgeColor => switch (this) {
    MovieVoteTier.excellent => Colors.green,
    MovieVoteTier.good => Colors.lightGreen,
    MovieVoteTier.average => Colors.orange,
    MovieVoteTier.poor => Colors.red,
  };
}

// Call site — no interface, no factory, no DI:
final color = movie.voteAverage.voteTier.badgeColor;
```

This replaces a `getColorForVote(double vote)` helper that every widget would otherwise import and call with a positional argument — the strategy travels with the value instead.

### Strategy via extension dispatching on a sealed hierarchy

```dart
sealed class PlaybackSource {}
class YoutubeSource extends PlaybackSource { final String videoId; YoutubeSource(this.videoId); }
class LocalSource extends PlaybackSource { final String path; LocalSource(this.path); }

extension PlaybackSourceLaunch on PlaybackSource {
  Future<void> play() => switch (this) {
    YoutubeSource(videoId: final id) => launchYoutube(id),
    LocalSource(path: final p) => launchLocal(p),
  };
}
```

Adding a new `PlaybackSource` subtype makes this `switch` non-exhaustive at compile time — the strategy for the new variant can't be forgotten.

## Anti-Patterns to Avoid

- **Duplicate strategies for the same job.** Don't ship two extension members that do the same thing under near-identical names (e.g. a `firstOrNull` and a `firstOrNull2` on the same type) — consolidate to one and delete the other; the duplicate is dead weight that invites callers to diverge for no reason.
- **Untyped extensions on core collections.** An extension like `dynamic get firstOrNull` on `List` throws away type safety for every caller — prefer a generic `extension <T> on List<T>` returning `T?`.
- **Grab-bag files.** A single `null_extensions.dart` mixing null-coalescing helpers, list utilities, and swap logic makes call sites hard to trace back to intent — split by capability instead.
- **Extensions that hide business rules.** If the "strategy" reads from a repository, calls an API, or mutates shared state, it's not a pure extension anymore — use dependency injection instead so the behavior stays testable and swappable.
