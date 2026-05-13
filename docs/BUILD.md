# Build and run

This project ships as an **iOS application** built through **Xcode** (`App.xcodeproj`). A **Swift Package** (`Package.swift`) describes the same `App` library and `UnitTests` target for dependency resolution and tooling, but the runnable `.app` and reliable tests use the **iOS SDK**.

## Requirements

- **macOS** with **Xcode** installed (use a release that includes the **iOS 18** SDK, matching `Package.swift` `platforms: [.iOS(.v18), ...]`).
- **Apple ID** (optional for Simulator; required on a physical device with signing).

The shared scheme was last upgraded with Xcode **16.x** (`LastUpgradeVersion = 1610` in the scheme). Newer Xcode versions are generally fine.

## Run the app (Xcode)

1. Clone the repository and open **`App.xcodeproj`** at the repo root.  
   Use the **project** file unless you maintain a local **workspace**; `*.xcworkspace` is gitignored in this repo.
2. In the toolbar, select the **App** scheme (default in the shared scheme).
3. Choose an **iOS Simulator** (for example any **iPhone** runtime with **iOS 18+**). If the list is empty, install a simulator runtime under **Xcode → Settings → Platforms** (or **Components** in older Xcode).
4. **Product → Run** (⌘R).

The first successful run resolves Swift packages (**EnvironmentOverrides**, **ViewInspector**) and may take a minute.

## Run unit tests

### From Xcode

1. Same scheme: **App** (the shared scheme attaches **UnitTests**).
2. **Product → Test** (⌘U).

### From Terminal (`xcodebuild`)

List destinations Xcode can use for this scheme:

```bash
cd /path/to/exp-travel
xcodebuild -project App.xcodeproj -scheme App -showdestinations
```

Pick an **iOS Simulator** line, then build and test:

```bash
xcodebuild \
  -project App.xcodeproj \
  -scheme App \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2' \
  test
```

Adjust `name` and `OS` to match an entry from `-showdestinations`. You can use `generic/platform=iOS Simulator` for a **build** only; **testing** usually needs a concrete simulator.

### Plain `swift test` on the command line

Running **`swift test`** from the repo root builds the package for the **host** platform (often **macOS**). This target imports **UIKit**, so the library **does not compile for macOS** in a default `swift test` invocation. Prefer **Xcode** or **`xcodebuild test`** with an **iOS Simulator** destination for this project.

## Command-line build (no tests)

```bash
cd /path/to/exp-travel
xcodebuild \
  -project App.xcodeproj \
  -scheme App \
  -destination 'generic/platform=iOS Simulator' \
  build
```

## Release archive (distribution)

1. Xcode: select **Any iOS Device** or **Generic iOS Platform**.
2. **Product → Archive**, then use the Organizer to export or upload.

Configure **Signing & Capabilities** with your team for device and App Store builds, and replace the placeholder `PRODUCT_BUNDLE_IDENTIFIER` (`com.template.App`).

## Troubleshooting

| Issue | What to try |
|--------|-------------|
| Swift package resolution errors | **File → Packages → Reset Package Caches**; check outbound HTTPS to GitHub. |
| No iOS simulators in the destination list | Install an iOS 18+ simulator runtime in Xcode settings. |
| Signing errors on a real device | Set **Team** under **Signing & Capabilities** for the **App** target. |
| Yellow SwiftData warning in the UI | `ModelContainer` creation failed; the app falls back to a stub container. Check console logs and simulator storage. |
| `xcodebuild` "device … not found" | Run `-showdestinations` and copy an exact **Simulator** `name` (and `OS` if required). |

## Related docs

- [ARCHITECTURE.md](ARCHITECTURE.md) — how the app is structured at runtime.
- [README.md](../README.md) — project background and feature overview.
