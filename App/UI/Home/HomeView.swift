//
//  HomeView.swift
//  App
//

import SwiftUI
import Combine

/// Template root screen.
///
/// Demonstrates the wiring this codebase expects from every screen:
///  - reads dependencies through `@Environment(\.injected)` (`DIContainer`),
///  - keeps screen-local routing in a `Routing` struct, mirrored into
///    `AppState.routing.home` via `Binding.dispatched(to:_:)` so deep
///    links and the view share one source of truth,
///  - uses `Inspection` to make the view testable with ViewInspector.
///
/// Replace the placeholder content with the real first screen of your app.
struct HomeView: View {

    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.home)
    }
    @State private var canRequestPushPermission: Bool = false

    let inspection = Inspection<Self>()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Welcome")
                    .font(.largeTitle)
                Text("Replace HomeView with the first screen of your app.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                if canRequestPushPermission {
                    Button(action: requestPushPermission) {
                        Text("Allow Push")
                    }
                }
            }
            .padding()
            .navigationTitle("Home")
        }
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onReceive(canRequestPushPermissionUpdate) { self.canRequestPushPermission = $0 }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

// MARK: - Side Effects

private extension HomeView {
    func requestPushPermission() {
        injected.interactors.userPermissions
            .request(permission: .pushNotifications)
    }
}

// MARK: - Routing

extension HomeView {
    /// Screen-local routing mirrored into `AppState.routing.home`.
    /// Add new flags here as the screen grows.
    struct Routing: Equatable { }
}

// MARK: - State Updates

private extension HomeView {

    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.home)
    }

    var canRequestPushPermissionUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: AppState.permissionKeyPath(for: .pushNotifications))
            .map { $0 == .notRequested || $0 == .denied }
            .eraseToAnyPublisher()
    }
}

#Preview {
    HomeView()
}
