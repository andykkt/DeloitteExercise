//
//  MainView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI
import Combine

struct MainView: View {
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: MainViewModel
    
    // MARK: - Private Members
    
    @State private var showIndicator: Bool = false
    @State private var focusSearch: Bool = false
    @State private var showSearchButton: Bool = false {
        didSet {
            viewModel.searchText = ""
        }
    }
    
    // MARK: - Content
    
    var body: some View {
        NavigationView {
            ZStack {
                FlickrBackground()
                    .blur(radius: 52.0)
                
                VStack {
                    topView
                    
                    Spacer()
                    
                    contentView
                }
            }
            .background(FlickrBackground())
            .navigationBarHidden(true)
            .onAppear() {
                print("[MainView: onAppear]")
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            idleView
        case .loaded:
            loadedView
        case .loading:
            loadingView
        case .failed(let error):
            failedView(with: error)
        }
    }
}

extension MainView {
    private var topView: some View {
        VStack {
            headerView
            
            if !showSearchButton {
                inputView
            }
        }
    }
    
    private var headerView: some View {
        ZStack {
            HStack {
                Spacer()
                
                Text(viewModel.lastSearchedText)
                    .foregroundColor(.white)
                    .flickrFont(style: .title)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                if showSearchButton {
                    Button(action: {
                        withAnimation {
                            showSearchButton = false
                        }
                    }, label: {
                        VStack {
                            Image(systemName: "magnifyingglass.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundColor(.white)
                        }
                    })
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                }
            }
        }
        .frame(height: 30)
    }
    
    private var inputView: some View {
        VStack {
            InputTextField("Search photos",
                           text: $viewModel.searchText)
            {
                viewModel.searchByText(for: viewModel.searchText)
                showSearchButton = true
                return true
            }
            .paddingLeft(8)
            .flickrFont(style: .body)
            .returnKeyType(.search)
            .foregroundColor(Color(UIColor.label))
            .background(Color(UIColor.systemGroupedBackground))
            .frame(height: 44)
            .cornerRadius(12.0)
            .padding()
            
            Spacer()
        }
        .frame(height: 52)
    }
    
    private var listView: some View {
        GeometryReader { geometry in
            ScrollViewOffset { proxy in
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          content: {
                            ForEach(viewModel.dataSource) { photo in
                                NavigationLink(
                                    destination: PhotoDetailView(viewModel: PhotoDetailViewModel(dataProvider: viewModel.dataProvider,
                                                                                                 photos: viewModel.dataSource,
                                                                                                 selected: photo)),
                                    label: {
                                        PhotoView(viewModel: photo)
                                    })
                                .id(photo.id)
                                .background(Color.mainBackground)
                                .onAppear() {
                                    if viewModel.isLastItem(photo) {
                                        viewModel.showPageLoading = true
                                    }
                                    
                                    if let lastSelection = viewModel.lastSelection {
                                        proxy.scrollTo(lastSelection.id)
                                        viewModel.lastSelection = nil
                                    }
                                }
                            }
                          })
                
                if viewModel.showPageLoading {
                    HStack {
                        Spacer()
                        LoadingIndicatorView()
                            .onAppear() {
                                viewModel.fetchNextPage()
                            }
                        Spacer()
                    }
                    .frame(height: 64)
                }
                
            } onOffsetChange: { offset in
                if showSearchButton, offset > 88 {
                    withAnimation() {
                        showSearchButton = false
                    }
                } else if !showSearchButton, offset < -88 {
                    withAnimation() {
                        showSearchButton = true
                    }
                }
            }
        }
    }
    
    private var idleView: some View {
        listView
            .disabled(true)
    }
    
    private var loadingView: some View {
        ZStack {
            listView
            
            if showIndicator {
                LoadingIndicatorView()
            }
        }
        .onAppear() {
            showIndicator.toggle()
        }
    }
    
    private var loadedView: some View {
        listView
    }
    
    private func failedView(with error: Error) -> some View {
        ErrorView(title: "Failed to sync data",
                  description: error.localizedDescription)
        {
            loadedView
        } action: {
            viewModel.resetState()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(dataProvider: MockDataProvider()))
        
        MainView(viewModel: MainViewModel(dataProvider: MockDataProvider(searchResponseType: .failed)))
        
        let viewModel = MainViewModel(dataProvider: MockDataProvider(), autoSearch: true)
        MainView(viewModel: viewModel)
            .onAppear() {
                triggerSearch(viewModel, search: "Any")
            }
    }
    
    static func triggerSearch(_ viewModel: MainViewModel, search: String) {
        Just(search).assign(to: &viewModel.$searchText)
    }
}
