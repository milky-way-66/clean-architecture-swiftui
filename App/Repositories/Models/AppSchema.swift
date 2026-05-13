//
//  AppSchema.swift
//  App
//

import SwiftData

/// Namespace for SwiftData `@Model` types. Add models as
/// `extension DBModel { @Model final class ... }` and register
/// them in `Schema.appSchema` below.
enum DBModel { }

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    /// Single source of truth for the SwiftData schema. Bump
    /// `actualVersion` when changing models in a non-additive way.
    static var appSchema: Schema {
        Schema([
            // Register `DBModel.*` types here, e.g. `DBModel.Item.self`.
        ], version: actualVersion)
    }
}
