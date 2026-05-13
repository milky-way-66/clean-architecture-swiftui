//
//  MockedInteractors.swift
//  UnitTests
//

import Testing
import SwiftUI
import ViewInspector
@testable import App

extension DIContainer.Interactors {
    static func mocked(
        images: [MockedImagesInteractor.Action] = [],
        permissions: [MockedUserPermissionsInteractor.Action] = []
    ) -> DIContainer.Interactors {
        self.init(
            images: MockedImagesInteractor(expected: images),
            userPermissions: MockedUserPermissionsInteractor(expected: permissions))
    }

    func verify(sourceLocation: SourceLocation = #_sourceLocation) {
        (images as? MockedImagesInteractor)?
            .verify(sourceLocation: sourceLocation)
        (userPermissions as? MockedUserPermissionsInteractor)?
            .verify(sourceLocation: sourceLocation)
    }
}

// MARK: - ImagesInteractor

struct MockedImagesInteractor: Mock, ImagesInteractor {

    enum Action: Equatable {
        case loadImage(URL?)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func load(image: LoadableSubject<UIImage>, url: URL?) {
        register(.loadImage(url))
    }
}

// MARK: - UserPermissionsInteractor

final class MockedUserPermissionsInteractor: Mock, UserPermissionsInteractor {

    enum Action: Equatable {
        case resolveStatus(Permission)
        case request(Permission)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func resolveStatus(for permission: Permission) {
        register(.resolveStatus(permission))
    }

    func request(permission: Permission) {
        register(.request(permission))
    }
}
