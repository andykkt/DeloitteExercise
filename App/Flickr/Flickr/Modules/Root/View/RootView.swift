//
//  RootView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct RootView: View {
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: RootViewModel
    
    // MARK: - Environments
    
    @EnvironmentObject var appState: AppState
    
    // MARK: - Content
    
    var body: some View {
        Group {
            contentView
        }
        .onAppear {
            print("[RootView: onAppear]")
            appState.load()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch appState.state {
        case .idle:
            idleView
        case .onboarding:
            OnboardingView()
        case .main:
            MainView(viewModel: MainViewModel(dataProvider: viewModel.dataProvider))
        }
    }
}

extension RootView {
    private var idleView: some View {
        ZStack {
            FlickrBackground()
                .blur(radius: 52.0)
        }
        .background(FlickrBackground())
        .ignoresSafeArea()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel(dataProvider: MockDataProvider()))
            .environmentObject(AppState.preview(state: .onboarding))
        
        RootView(viewModel: RootViewModel(dataProvider: MockDataProvider()))
            .environmentObject(AppState.preview(state: .main))
    }
}
