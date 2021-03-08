//
//  PhotoDetailView.swift
//  Flickr
//
//  Created by Andy Kim on 7/3/21.
//

import SwiftUI

struct PhotoDetailView: View {
    
    // MARK: - Definitions
    
    struct Constant {
        static let spacing: CGFloat = 4
        static let minDistance: CGFloat = 40
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: PhotoDetailViewModel
    
    // MARK: - Private Members
    
    @State private var offsetX: CGFloat = 0
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width - (Constant.spacing * 2)
    @State private var count: CGFloat = 0
    @State private var position: CGFloat = 0
    @State private var hasAnimation: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // MARK: - Content
    
    var body: some View {
        ZStack {
            FlickrBackground()
                .blur(radius: 52.0)
            
            carouselView
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .padding(.all, 20)
                    })
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .onAppear() {
            print("[PhotoDetailView: onAppear]")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(FlickrBackground())
    }
    
    private var carouselView: some View {
        VStack {
            LazyHStack(spacing: Constant.spacing) {
                ForEach(viewModel.photos) { photo in
                    VStack {
                        HStack {
                            Text("\(photo.photo.ownername ?? "Unknown")")
                                .foregroundColor(.white)
                                .flickrFont(style: .body)
                            
                            Spacer()
                        }
                        .padding(.all, 20)
                        
                        PhotoView(viewModel: photo)
                        
                        Spacer()
                        
                        HStack {
                            Text("\(photo.photo.title)")
                                .foregroundColor(.white)
                                .flickrFont(style: .body)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .background(Color.mainBackground)
                    .id(photo.photo.id)
                    .frame(width: screenWidth)
                    .offset(x: offsetX)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged({ (value) in
                                if value.translation.width > 0 {
                                    offsetX = value.location.x
                                } else {
                                    offsetX = value.location.x - screenWidth
                                }
                            })
                            .onEnded({ (value) in
                                if value.translation.width > 0 {
                                    if value.translation.width > ((screenWidth - Constant.minDistance) / 2) && Int(count) != 0 {
                                        count -= 1
                                        offsetX = -((screenWidth + Constant.spacing) * count)
                                    } else {
                                        offsetX = -((screenWidth + Constant.spacing) * count)
                                    }
                                } else {
                                    if -value.translation.width > ((screenWidth - Constant.minDistance) / 2) && Int(count) != (viewModel.photos.count - 1) {
                                        count += 1
                                        offsetX = -((screenWidth + Constant.spacing) * count)
                                    } else {
                                        offsetX = -((screenWidth + Constant.spacing) * count)
                                    }
                                }
                            })
                    )
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            .offset(x: position)
            .animation(hasAnimation ? .spring() : .none)
        }
        .onAppear() {
            position = ((screenWidth + Constant.spacing) * CGFloat(viewModel.photos.count / 2)) - (viewModel.photos.count % 2 == 0 ? ((screenWidth) / 2) : 0)
            print("position: \(position)")
            
            let index = CGFloat(viewModel.indexOfSelected())
            count = index
            offsetX = -((screenWidth + Constant.spacing) * count)
            
            DispatchQueue.main.async {
                hasAnimation = true
            }
        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let response = MockDataLoader<MainAPI.Search.Response>(fileName: "SearchResponse",
                                                                 decoder: decoder)
        let photos = response.data.photos.photo.map{ PhotoViewModel(dataProvider: MockDataProvider(), photo: $0) }
        PhotoDetailView(viewModel: PhotoDetailViewModel(dataProvider: MockDataProvider(), photos: photos, selected: photos.first!))
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
