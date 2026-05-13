//
//  DeepLinksHandlerTests.swift
//  UnitTests
//

import Testing
@testable import App

@MainActor
@Suite struct DeepLinksHandlerTests {

    @Test func noSideEffectOnInit() {
        let interactors: DIContainer.Interactors = .mocked()
        let container = DIContainer(appState: AppState(), interactors: interactors)
        _ = RealDeepLinksHandler(container: container)
        interactors.verify()
        #expect(container.appState.value == AppState())
    }

    @Test func openingDeeplinkFromDefaultRouting() {
        let interactors: DIContainer.Interactors = .mocked()
        let initialState = AppState()
        let container = DIContainer(appState: initialState, interactors: interactors)
        let sut = RealDeepLinksHandler(container: container)
        sut.open(deepLink: .home)
        interactors.verify()
        // The default `.home` link keeps routing at its default value.
        #expect(container.appState.value == AppState())
    }

    @Test func openingDeeplinkFromNonDefaultRouting() async throws {
        let interactors: DIContainer.Interactors = .mocked()
        let initialState = AppState()
        let container = DIContainer(appState: initialState, interactors: interactors)
        let sut = RealDeepLinksHandler(container: container)
        // Simulate a non-default routing state, then open the deep link
        // to assert routing is reset back to default.
        container.appState[\.system.isActive] = true
        sut.open(deepLink: .home)
        try await Task.sleep(nanoseconds: 10_000_000)
        interactors.verify()
        // `.home` resets `routing` to default; other parts of state are unchanged.
        #expect(container.appState.value.routing == AppState.ViewRouting())
    }

    @Test func parseURLAcceptsHomeHost() {
        #expect(DeepLink(url: URL(string: "https://www.example.com")!) == .home)
        #expect(DeepLink(url: URL(string: "https://www.example.com/")!) == .home)
        #expect(DeepLink(url: URL(string: "https://www.example.com/home")!) == .home)
    }

    @Test func parseURLRejectsUnknownHost() {
        #expect(DeepLink(url: URL(string: "https://www.unknown.com/home")!) == nil)
    }
}
