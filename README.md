# App — SwiftUI Clean Architecture Template

A starter iOS codebase derived from [nalexn/clean-architecture-swiftui](https://github.com/nalexn/clean-architecture-swiftui). All app-specific screens have been stripped out, leaving the **architecture skeleton** you can fork for a new SwiftUI app.

> See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full layering and runtime overview, and [docs/BUILD.md](docs/BUILD.md) for build and test instructions.

## What's in the box

| Area | Choice |
|------|--------|
| UI | SwiftUI (`NavigationStack`, `.searchable`, `.refreshable`, sheets) |
| Persistence | SwiftData (`@Model`, `ModelContainer`, `@Query`-driven views) |
| Reactive state | Combine (`Store` = `CurrentValueSubject`, `Loadable<T>` + `CancelBag`) |
| Networking | `URLSession` + `WebRepository` helper + typed `APICall` + `APIError` |
| Permissions | Push notifications (`UserPermissionsInteractor`) |
| Image loading | `ImagesInteractor` + `ImagesWebRepository` + `ImageView` |
| Deep links | `DeepLinksHandler` + `DeepLink` enum (universal-link template) |
| System events | `SystemEventsHandler` (keyboard, scene active, push registration) |
| Package manager | Swift Package Manager (`Package.swift`) + `App.xcodeproj` |
| Platforms | iOS 18+ (UIKit bridge for `AppDelegate` / scenes) |
| Dev / QA | [EnvironmentOverrides](https://github.com/nalexn/EnvironmentOverrides), [ViewInspector](https://github.com/nalexn/ViewInspector) |

## Architecture at a glance

Dependencies point **inward**: views depend on interactors and read-only `AppState`; interactors depend on repository protocols; repositories depend on Foundation / SwiftData / UIKit.

```
UI (SwiftUI)
   ↓ @Environment(\.injected)
Interactors (use cases)
   ↓ protocols
Repositories (Web + SwiftData)
   ↑
Core: AppState · DeepLinksHandler · PushNotificationsHandler · SystemEventsHandler
   ↑
AppEnvironment.bootstrap()   ← composition root
```

The composition root (`App/DependencyInjection/AppEnvironment.swift`) is the **only** place that wires concrete types. Views read services through `DIContainer` injected into `EnvironmentValues.injected`.

## Project layout

```
App/
  Core/                          App entry, delegates, AppState, system handlers
  DependencyInjection/           AppEnvironment (composition root) + DIContainer
  Interactors/                   Use cases (Images, UserPermissions, ...)
  Repositories/
    WebAPI/                      WebRepository + Images + PushToken (+ your APIs)
    Database/                    ModelContainer + MainDBRepository (@ModelActor)
    Models/                      AppSchema (SwiftData) + your DBModel / ApiModel
  UI/
    Common/                      ImageView, ErrorView, Query+Search
    Home/                        Template root screen (replace this)
    RootViewModifier.swift       Background blur when inactive
  Utilities/                     Store, Loadable, CancelBag, Helpers
  Resources/                     Assets.xcassets, Localizable.xcstrings

UnitTests/
  Mocks/                         Mock harness + interactor / repo mocks
  Repositories/                  WebRepository + ImageWebRepository tests
  System/                        DeepLinks + Push notifications tests
  UI/                            RootViewAppearance + ImageView tests
  Utilities/                     Loadable / Helpers tests
```

## Adding a feature

Follow the *Extension points* checklist in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md):

1. Add a **repository protocol** + a `Real*` implementation under `App/Repositories/WebAPI/` or extend `MainDBRepository` under `App/Repositories/Database/`.
2. Add an **interactor** (`protocol` + `Real*` + `Stub*`) under `App/Interactors/` and wire it in `AppEnvironment.configuredInteractors`.
3. Expose it on `DIContainer.Interactors` so views can read it via `@Environment(\.injected)`.
4. Extend `AppState` routing or permissions if global coordination is required.
5. Add a SwiftUI screen under `App/UI/<Feature>/` and reach interactors / state through `injected`.
6. Mirror the new protocol with a mock under `UnitTests/Mocks/` and add tests beside the existing layout.

## Build & test

See [`docs/BUILD.md`](docs/BUILD.md). Short version:

```bash
# Run the app
open App.xcodeproj  # then ⌘R on an iOS Simulator

# Tests from the command line
xcodebuild \
  -project App.xcodeproj \
  -scheme App \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2' \
  test
```

## Credits

Forked from [nalexn/clean-architecture-swiftui](https://github.com/nalexn/clean-architecture-swiftui) (MIT). The original demo app has been removed so this repo can be used as a generic template.
