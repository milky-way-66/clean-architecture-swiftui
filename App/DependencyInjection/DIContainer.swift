//
//  DIContainer.swift
//  App
//

import SwiftUI
import SwiftData

struct DIContainer {

    let appState: Store<AppState>
    let interactors: Interactors

    init(appState: Store<AppState> = .init(AppState()), interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }

    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
}

extension DIContainer {
    /// Group of web repositories injected at the composition root.
    /// Add new web repositories here as features are added.
    struct WebRepositories {
        let images: ImagesWebRepository
        let pushToken: PushTokenWebRepository
    }

    /// Group of database repositories injected at the composition root.
    /// `MainDBRepository` is a `@ModelActor` shared by all DB repository
    /// protocols implemented in the app.
    struct DBRepositories {
        let main: MainDBRepository
    }

    /// Group of use-case interactors exposed to the UI through `DIContainer`.
    /// Add new interactors here as features are added.
    struct Interactors {
        let images: ImagesInteractor
        let userPermissions: UserPermissionsInteractor

        static var stub: Self {
            .init(images: StubImagesInteractor(),
                  userPermissions: StubUserPermissionsInteractor())
        }
    }
}

extension EnvironmentValues {
    @Entry var injected: DIContainer = DIContainer(appState: AppState(), interactors: .stub)
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
