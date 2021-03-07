//
//  AppStateTests.swift
//  FlickrTests
//
//  Created by Andy Kim on 7/3/21.
//

import XCTest
import Combine
@testable import Flickr

class AppStateTests: XCTestCase {
    private var disposables = Set<AnyCancellable>()
    let appState = AppState()
    
    func testStateOnboarding() throws {
        XCTAssertEqual(appState.state, .idle)
        let isOnboardedFromUserDefaults = UserDefaults.standard.bool(forKey: AppStorageKey.kIsOnboarded)
        XCTAssertEqual(appState.isOnboarded, isOnboardedFromUserDefaults)
        
        let expectation = XCTestExpectation(description: "AppState.State Changes")
        appState.$state.sink { state in
            print("state: \(state)")
            if state == .main {
                expectation.fulfill()
            }
        }.store(in: &disposables)
        
        appState.onboarded()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testStateMain() throws {
        appState.state = .idle
        appState.isOnboarded = true
        
        let expectation = XCTestExpectation(description: "AppState.State Changes")
        appState.$state.sink { state in
            print("state: \(state)")
            if state == .main {
                expectation.fulfill()
            }
        }.store(in: &disposables)
        
        appState.load()
        wait(for: [expectation], timeout: 10.0)
    }
}
