//
//  AppState.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI
import Combine

class AppState: NSObject, ObservableObject {
    enum State {
        case idle
        case onboarding
        case main
    }
    
    @Published var state: State
    @AppStorage(AppStorageKey.kIsOnboarded) var isOnboarded: Bool = false
    
    // MARK: - Init
    
    override init() {
        self.state = .idle
        super.init()
    }
    
}

#if DEBUG
extension AppState {
    static func preview(state: AppState.State) -> AppState {
        let appState = AppState()
        appState.state = state
        return appState
    }
}
#endif
