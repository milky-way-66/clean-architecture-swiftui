//
//  DeepLinksHandler.swift
//  App
//

import Foundation

/// A simple universal-link schema as a template.
///
/// Replace `host == "www.example.com"` with your app's host and add
/// new cases for each in-app destination. The handler below applies
/// the link to `AppState.routing` so deep links and views share a
/// single source of truth.
enum DeepLink: Equatable {

    case home

    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "www.example.com"
        else { return nil }
        switch components.path {
        case "", "/", "/home":
            self = .home
        default:
            return nil
        }
    }
}

// MARK: - DeepLinksHandler

@MainActor
protocol DeepLinksHandler {
    func open(deepLink: DeepLink)
}

struct RealDeepLinksHandler: DeepLinksHandler {

    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func open(deepLink: DeepLink) {
        switch deepLink {
        case .home:
            let routeToDestination = {
                self.container.appState.bulkUpdate { _ in
                    // Apply the destination routing here for new cases.
                    // Example pattern (kept as a template):
                    //   $0.routing.home.someSheet = true
                }
            }
            /*
             SwiftUI is unable to perform complex navigation involving
             simultaneous dismissal of older screens and presenting new ones.
             A workaround is to perform the navigation in two steps.
             */
            let defaultRouting = AppState.ViewRouting()
            if container.appState.value.routing != defaultRouting {
                self.container.appState[\.routing] = defaultRouting
                let delay: DispatchTime = .now() + (ProcessInfo.processInfo.isRunningTests ? 0 : 1.5)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: routeToDestination)
            } else {
                routeToDestination()
            }
        }
    }
}
