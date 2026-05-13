---
name: exp-travel-ios
description: >-
  Use when working on the App iOS template — architecture, new features,
  refactors, or tests. Ensures alignment with DIContainer, interactors,
  repositories, and GitNexus indexing.
---

# App template iOS project

1. Read `.cursor/rules/architecture.mdc` and `.cursor/rules/swift-ios-conventions.mdc` before changing production Swift code.
2. Follow the layer boundaries: UI → interactors → repositories; composition only in `AppEnvironment.bootstrap()`.
3. For "how does this work?", "what breaks if I change X?", or multi-file refactors, use GitNexus per `.cursor/rules/gitnexus-workflow.mdc` (run `npx gitnexus analyze` from repo root if the index is stale).
