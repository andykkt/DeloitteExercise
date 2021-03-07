//
//  NetworkDataProvider.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation
import Combine

class NetworkDataProvider: DataProvidable {
    
    // MARK: - MainAPIs
    
    func search(for text: String, page: Int, perPage: Int) -> AnyPublisher<MainAPI.Search.Response, DataError> {
        return MainAPI.Search.fetch(path: .init(),
                                    queryParameters: .init(text: text, perPage: perPage, page: page, extras: [.Small320, .Small, .OwnerName]))
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func getImage(from url: String) -> AnyPublisher<Data, DataError> {
        let imageURL = URL(string: url)!
        return URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { $0.data }
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
