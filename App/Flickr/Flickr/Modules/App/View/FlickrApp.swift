//
//  FlickrApp.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

@main
struct FlickrApp: App {
    
    // MARK: - Environments
    
    private let appState = AppState()
    
    // MARK: - Content
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(dataProvider: NetworkDataProvider()))
                .environmentObject(appState)
        }
    }
}
