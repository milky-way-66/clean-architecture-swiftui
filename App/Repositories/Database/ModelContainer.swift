//
//  ModelContainer.swift
//  App
//

import SwiftData

extension ModelContainer {

    /// Build the production `ModelContainer` from `Schema.appSchema`.
    /// Set `inMemoryOnly` for previews/tests. `isStub` is used as a
    /// fallback when on-disk creation fails so the UI can still render.
    static func appModelContainer(
        inMemoryOnly: Bool = false, isStub: Bool = false
    ) throws -> ModelContainer {
        let schema = Schema.appSchema
        let modelConfiguration = ModelConfiguration(isStub ? "stub" : nil, schema: schema, isStoredInMemoryOnly: inMemoryOnly)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    static var stub: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: true)
    }

    var isStub: Bool {
        return configurations.first?.name == "stub"
    }
}

/// Shared `@ModelActor` used by all DB repository protocols.
///
/// Conform to feature-specific protocols (e.g. `protocol ItemsDBRepository`)
/// in an `extension MainDBRepository: ItemsDBRepository { ... }` file
/// inside `Repositories/Database/`.
@ModelActor
final actor MainDBRepository { }
