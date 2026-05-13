//
//  HelpersTests.swift
//  UnitTests
//
//  Created by Alexey Naumov on 27.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation
import Testing
@testable import App

@Suite struct HelpersTests {

    @Test func localizedDefaultLocale() {
        let sut = "Home".localized(Locale.backendDefault)
        #expect(sut == "Home")
    }

    @Test func localizedKnownLocale() {
        let sut = "Home".localized(Locale(identifier: "de"))
        #expect(sut == "Startseite")
    }

    @Test func localizedUnknownLocale() {
        let sut = "Home".localized(Locale(identifier: "ch"))
        #expect(sut == "Home")
    }

    @Test func resultIsSuccess() {
        let sut1 = Result<Void, Error>.success(())
        let sut2 = Result<Void, Error>.failure(NSError.test)
        #expect(sut1.isSuccess)
        #expect(!sut2.isSuccess)
    }
}
