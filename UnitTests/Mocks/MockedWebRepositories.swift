//
//  MockedWebRepositories.swift
//  UnitTests
//

import Foundation
import UIKit.UIImage
@testable import App

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
}

// MARK: - ImagesWebRepository

final class MockedImageWebRepository: TestWebRepository, Mock, ImagesWebRepository {

    enum Action: Equatable {
        case loadImage(URL)
    }
    var actions = MockActions<Action>(expected: [])

    var imageResponses: [Result<UIImage, Error>] = []

    func loadImage(url: URL) async throws -> UIImage {
        register(.loadImage(url))
        guard !imageResponses.isEmpty else { throw MockError.valueNotSet }
        return try imageResponses.removeFirst().get()
    }
}

// MARK: - PushTokenWebRepository

final class MockedPushTokenWebRepository: TestWebRepository, Mock, PushTokenWebRepository {
    enum Action: Equatable {
        case register(Data)
    }
    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = MockActions<Action>(expected: expected)
    }

    func register(devicePushToken: Data) async throws {
        register(.register(devicePushToken))
    }
}
