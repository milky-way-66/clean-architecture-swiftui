//
//  MockedDBRepositories.swift
//  UnitTests
//

import SwiftData
@testable import App

extension ModelContainer {

    /// In-memory `ModelContainer` for tests built from `Schema.appSchema`.
    /// Add feature-specific DB-repo mocks below as new repository
    /// protocols are added to the codebase.
    static var mock: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: false)
    }
}
