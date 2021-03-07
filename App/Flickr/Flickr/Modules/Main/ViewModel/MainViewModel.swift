//
//  MainViewModel.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject, Identifiable {
    
    // MARK: - Dependencies
    
    let dataProvider: DataProvidable
    
    // MARK: - Definitions
    
    enum State {
        case idle
        case loading
        case loaded
        case failed(Error)
    }
    
    // MARK: - Public Variables
    
    @Published var state: State = .idle
    @Published var dataSource: [PhotoViewModel] = []
    @Published var searchText: String = ""
    @Published var lastSearchedText: String = "Photos"
    @Published var showPageLoading: Bool = false
    var lastSelection: PhotoViewModel?
    
    // MARK: - Private Variables
    
    private var disposables = Set<AnyCancellable>()
    private var bindingText: AnyCancellable? = nil
    private var currentPage: Int = 0
    
    // MARK: - Init
    
    init(dataProvider: DataProvidable, autoSearch: Bool = false) {
        self.dataProvider = dataProvider
        
        DispatchQueue.main.async {
            self.state = .loaded
        }
        
        if autoSearch {
            // Binding searchText
            bindingText = $searchText
                .dropFirst(1)
                .removeDuplicates()
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue(label: "SearchByTextQueue"))
                .sink(receiveValue: searchByText(for:))
        }
    }
    
    // MARK: - Private Functions
    
    private func fetch(searchText: String, page: Int) {
        dataProvider.search(for: lastSearchedText, page: currentPage + 1)
            .map { response in
                response.photos.photo.map { PhotoViewModel(dataProvider: self.dataProvider, photo: $0) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.dataSource = []
                    self.showPageLoading = false
                    self.state = .failed(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] photos in
                guard let self = self else { return }
                self.state = .loaded
                self.dataSource.append(contentsOf: photos)
                self.showPageLoading = false
            }
            .store(in: &disposables)
    }
    
    // MARK: - Public Functions
    
    func searchByText(for text: String) {
        guard !text.isEmpty else { return }
        
        disposables.forEach { $0.cancel() }
        
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        dataSource = []
        currentPage = 0
        lastSearchedText = text
        
        fetch(searchText: text, page: currentPage + 1)
    }
    
    func fetchNextPage() {
        DispatchQueue.main.async {
            self.showPageLoading = true
        }
        
        currentPage += 1
        
        fetch(searchText: lastSearchedText, page: currentPage + 1)
    }
    
    func resetState() {
        dataSource = []
        currentPage = 0
        state = .loaded
    }

    func isLastItem(_ photo: PhotoViewModel) -> Bool {
        return dataSource.last == photo
    }
}
