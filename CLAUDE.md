# Claude Guide — App (SwiftUI Clean Architecture template)

## Read this first: Architecture

**Before making any non-trivial change, read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).** It is the source of truth for how this iOS template is layered and wired:

- **Composition root** — `AppEnvironment.bootstrap()` builds `URLSession` → web repos → `ModelContainer` → DB repos → interactors → `DIContainer` → system handlers.
- **Layers (dependencies point inward)** — `UI/` → `Interactors/` → `Repositories/` (Web + SwiftData); cross-cutting via `Core/` (`AppState`, `DeepLinksHandler`, `PushNotificationsHandler`, `SystemEventsHandler`).
- **State** — `Store<AppState>` (Combine `CurrentValueSubject`), `Loadable<T>` + `CancelBag`, per-screen `Routing` structs mirrored into `AppState.ViewRouting`.
- **Persistence** — SwiftData `@Model` types under `DBModel` namespace, accessed through `MainDBRepository` (`@ModelActor`); register types in `Schema.appSchema`.
- **Networking** — shared `WebRepository` helper + `APICall` enum; errors normalized to `APIError`.
- **Adding a feature** — follow the *Extension points* checklist in `ARCHITECTURE.md` (repo protocol → interactor → `DIContainer` → `AppState` routing → tests).

> If a request would violate a layer boundary described in `ARCHITECTURE.md` (e.g. a view calling `URLSession`, or a repository touching `AppState`), stop and flag it before editing.

Related docs:

- [`docs/BUILD.md`](docs/BUILD.md) — Xcode / `xcodebuild` / simulator / tests.
- `.cursor/rules/architecture.mdc` — enforced layer rules aligned with the architecture doc.
- `.cursor/rules/swift-ios-conventions.mdc` — style and access-control conventions.

---

<!-- gitnexus:start -->
# GitNexus — Code Intelligence (optional)

This project can be indexed with [GitNexus](https://github.com/) for structure-aware navigation, impact analysis, and refactors. If the index is missing or stale, run `npx gitnexus analyze` at the repo root.

## When to use GitNexus

- **Before editing a function/class/method:** run `gitnexus_impact({target: "symbolName", direction: "upstream"})` to see the blast radius (direct callers, affected execution flows, risk level). Warn the user before editing HIGH or CRITICAL risk symbols.
- **Before committing:** run `gitnexus_detect_changes()` to verify the change set only touches expected symbols.
- **For "how does X work?" or "what calls Y?":** use `gitnexus_query({query: "concept"})` (process-grouped results) or `gitnexus_context({name: "symbolName"})` (full context: callers, callees, processes).
- **For renames:** use `gitnexus_rename` (call-graph aware) instead of find-and-replace.

## Skills

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
