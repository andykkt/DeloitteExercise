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
    
    // MARK: - Public Functions
    
    func onboarded() {
        isOnboarded = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.state = .main
            }
        }
    }
    
    func load() {
        withAnimation(.easeInOut(duration: 1.5)) {
            if isOnboarded {
                self.state = .main
            } else {
                self.state = .onboarding
            }
        }
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
