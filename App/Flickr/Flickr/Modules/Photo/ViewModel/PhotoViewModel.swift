//
//  PhotoViewModel.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI
import Combine

class PhotoViewModel: ObservableObject, Identifiable {
    
    // MARK: - Definitions
    
    struct Constant {
        static let minimumSize: CGFloat = 50.0
    }
    
    // MARK: - Dependencies
    
    let dataProvider: DataProvidable
    let photo: Photo
    
    // MARK: - Definitions
    
    enum State {
        case idle
        case loading
        case loaded
        case failed(Error)
    }
    
    // MARK: - Public Variables
    
    @Published var state: State = .idle
    @Published var image: UIImage?
    
    // MARK: - Private Members
    
    private var cachedImage = CachedImage.shared
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(dataProvider: DataProvidable, photo: Photo) {
        self.photo = photo
        self.dataProvider = dataProvider
        load()
    }
    
    deinit {
        disposables.forEach{ $0.cancel() }
    }
    
    // MARK: - Private Functions
    
    private func imageFromCache() -> Bool {
        guard let url = [photo.urlN, photo.urlS].compactMap({$0}).first
        else {
            print("[PhotoViewModel: imageFromCache] Failed to get url from Photo: \(photo)")
            return false
        }
        guard let cacheImage = cachedImage.get(key: url) else {
            return false
        }
        image = cacheImage
        return true
    }
    
    private func imageFromRemoteUrl() {
        guard let url = photo.urlN else {
            return
        }
        
        dataProvider.getImage(from: url)
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.image = nil
                    self.state = .failed(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] remoteImage in
                guard let self = self else { return }
                guard let remoteImage = remoteImage else { return }
                self.state = .loaded
                self.cachedImage.set(key: self.photo.id, image: remoteImage)
                self.image = remoteImage
            }
            .store(in: &disposables)
    }
    
    // MARK: - Public Functions
    
    var size: CGSize {
        let width = [photo.widthN, photo.widthS].compactMap({$0}).first ?? Int(Constant.minimumSize)
        let height = [photo.heightN, photo.heightS].compactMap({$0}).first ?? Int(Constant.minimumSize)
        return CGSize(width: width, height: height)
    }
    
    func load() {
        state = .loading
        if imageFromCache() {
            state = .loaded
            return
        }
        imageFromRemoteUrl()
        state = .loaded
    }
}

extension PhotoViewModel: Equatable {
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
