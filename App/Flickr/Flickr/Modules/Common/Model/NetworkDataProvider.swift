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
    
    func search(for text: String) -> AnyPublisher<MainAPI.Search.Response, DataError> {
        return MainAPI.Search.fetch(path: .init(),
                                    queryParameters: .init(text: text, perPage: 50))
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
        
    }

}
