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
    
    func search(for text: String) -> AnyPublisher<MainAPI.Search.Response, DataError>
}
