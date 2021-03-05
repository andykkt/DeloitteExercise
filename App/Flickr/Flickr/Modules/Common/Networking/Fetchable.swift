//
//  Fetchable.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation
import Combine

protocol Fetchable: Requestable {
    associatedtype Response: Decodable
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    static var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy { get }
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

extension Fetchable {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .deferredToDate
    }
    
    static var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        return .deferredToData
    }
    
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .useDefaultKeys
    }
}

extension Fetchable {
    static func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, RequestableError> {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
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
                    return RequestableError.decoding(error: error, data: data)
                }  else {
                    return RequestableError.underlying(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    static func fetch(path: Path,
                     parameters: Parameter? = nil,
                     httpHeaderParameters: HttpHeaderParameter? = nil,
                     queryParameters: QueryParameter? = nil) -> AnyPublisher<Response, RequestableError>
    {
        request(path: path,
                parameters: parameters,
                httpHeaderParameters: httpHeaderParameters,
                queryParameters: queryParameters)
            .flatMap(maxPublishers: .max(1)) { data in
                decode(data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
