//
//  PhotoView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct PhotoView: View {
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: PhotoViewModel
    
    // MARK: - Content
    
    var body: some View {
        ZStack {
            Color.mainBackground
            
            contentView
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
        case .failed:
            failedView
        }
    }
}

extension PhotoView {
    private var failedView: some View {
        EmptyView()
    }
    
    private var loadingView: some View {
        loadedView
            .blur(radius: 10)
    }
    
    @ViewBuilder
    private var loadedView: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(width: 80, height: 80)
                .opacity(0.2)
        }
    }
    
    private var idleView: some View {
        EmptyView()
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let loader = MockDataLoader<Photo>(fileName: "SinglePhotoResponse",
                                           decoder: decoder)
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                      content: {
                        ForEach(0..<100) { photo in
                            PhotoView(viewModel: PhotoViewModel(dataProvider: MockDataProvider(),
                                                                photo: loader.data))
                        }
                      })
        }
        .padding(.horizontal, 20)
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
