//
//  DataProvidable.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation
import Combine

enum DataError: Error {
  case parsing(description: String)
  case network(description: String)
}

protocol DataProvidable {
    
    // MARK: - MainAPI
    
    func search(for text: String, page: Int, perPage: Int) -> AnyPublisher<MainAPI.Search.Response, DataError>
    func getImage(from url: String) -> AnyPublisher<Data, DataError>
}

extension DataProvidable {
    func search(for text: String, page: Int) -> AnyPublisher<MainAPI.Search.Response, DataError> {
        return search(for: text, page: page, perPage: 100)
    }
}
