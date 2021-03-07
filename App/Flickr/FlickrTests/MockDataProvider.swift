//
//  MockDataProvider.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import Foundation
import Combine
import UIKit
@testable import Flickr

class MockDataProvider: DataProvidable {
    
    // MARK: - Definitions
    
    enum SearchResponseType: String {
        case success = "SearchResponse"
        case failed
    }
    
    enum PhotoResponseType: String {
        case success = "PhotoResponse"
        case failed
    }
    
    // MARK: - Private Variables
    
    private var searchResponseType: SearchResponseType
    private var photoResponseType: PhotoResponseType
    
    // MARK: - Init
    
    init(searchResponseType: SearchResponseType = .success,
         photoResponseType: PhotoResponseType = .success) {
        self.searchResponseType = searchResponseType
        self.photoResponseType = photoResponseType
    }
    
    // MARK: - Private Functions
    
    private func decode<T: Decodable>(_ data: Data, decoder: JSONDecoder) -> AnyPublisher<T, DataError> {
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    print("[Decode Error] \(errorToReport)")
                    return .parsing(description: errorToReport)
                }  else {
                    return .parsing(description: error.localizedDescription)
                }
            }
            .delay(for: 1.3, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func load<T: Decodable>(_ filename: String,_ decoder: JSONDecoder) -> AnyPublisher<T, DataError> {
        guard let path = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json") else {
            let error = DataError.network(description: "Couldn't locate mock data")
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let data = try? Data(contentsOf: path) else {
            let error = DataError.network(description: "Failed to decode")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return decode(data, decoder: decoder)
    }
    
    // MARK: - DataProvidable
    
    func search(for text: String, page: Int, perPage: Int = 50) -> AnyPublisher<MainAPI.Search.Response, DataError> {
        if searchResponseType == .failed {
            let error = DataError.network(description: "Failed to request")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return load(searchResponseType.rawValue, decoder)
    }
    
    func getImage(from url: String) -> AnyPublisher<Data, DataError> {
        if photoResponseType == .failed {
            let error = DataError.network(description: "Failed to request")
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let path = Bundle(for: type(of: self)).url(forResource: photoResponseType.rawValue, withExtension: "jpeg") else {
            let error = DataError.network(description: "Couldn't locate mock data")
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let data = try? Data(contentsOf: path) else {
            let error = DataError.network(description: "Failed to decode")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(data)
            .mapError { error in
                .parsing(description: error.localizedDescription)
            }
            .delay(for: 1.3, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
