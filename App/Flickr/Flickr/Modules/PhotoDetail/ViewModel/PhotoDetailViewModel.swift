//
//  PhotoDetailViewModel.swift
//  Flickr
//
//  Created by Andy Kim on 7/3/21.
//

import SwiftUI
import Combine

class PhotoDetailViewModel: ObservableObject, Identifiable {
    
    // MARK: - Definitions
    
    enum State {
        case idle
        case loading
        case loaded
        case failed(Error)
    }
    
    // MARK: - Dependencies
    
    let dataProvider: DataProvidable
    let photos: [PhotoViewModel]
    let selected: PhotoViewModel
    
    // MARK: - Public Members
    
    @Published var state: State = .idle
    
    // MARK: init
    
    init(dataProvider: DataProvidable, photos: [PhotoViewModel], selected: PhotoViewModel) {
        self.dataProvider = dataProvider
        self.photos = photos
        self.selected = selected
    }
    
    // MARK: - Public Members
    
    func indexOfSelected() -> Int {
        return photos.firstIndex(of: selected) ?? 0
    }
}
