//
//  Requestable.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

enum RequestableError: Error, CustomDebugStringConvertible {
    case invalidUrl(urlString: String)
    case encoding(error: EncodingError)
    case decoding(error: DecodingError, data: Data)
    case underlying(error: Error)
    case statusCode(code: Int, response: HTTPURLResponse, data: Data)
    case logicError(key: String, description: String)
    case nonHTTPResponse
    
    var debugDescription: String {
        switch self {
        case .invalidUrl(urlString: let url):
            return "Invalid URL: \(url)"
        case .underlying(error: let error):
            return String(describing: error)
        case .encoding(error: let error):
            return String(describing: error)
        case .decoding(error: let error, data: let data):
            return [String(describing: error), String(data: data, encoding: .utf8).map { "JSON: \($0)" }]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .statusCode(code: _, response: let response, data: let data):
            return [response.description, String(data: data, encoding: .utf8).map { "JSON: \($0)" }]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .logicError(let key, let description):
            return "\(key): \(description)"
        case .nonHTTPResponse:
            return "Non http response"
        }
    }
}

enum Request {
    enum NoParameter: Encodable {
        func encode(to encoder: Encoder) throws {}
    }
    
    enum NoHeader: Encodable {
        func encode(to encoder: Encoder) throws {}
    }
    
    enum ParameterEncoding {
        case formURL
        case json
        case xml
        case custom(contentType: String, transform: (Data) throws -> Data?)

        var contentType: String {
            switch self {
            case .formURL:
                return "application/x-www-form-urlencoded"
            case .json:
                return "application/json"
            case .xml:
                return "application/xml"
            case let .custom(type, _):
                return type
            }
        }
    }
    
    enum Method: String, CustomStringConvertible {
        case get
        case head
        case post
        case put
        case delete
        case patch
        
        var description: String {
            return rawValue.uppercased()
        }
    }
}

struct RequestableGenericResponseError: Decodable, Error, CustomStringConvertible {
    let code: Int
    let status: Int
    let message: String
    let developerMessage: String?

    var description: String {
        "\(status) | \(code) | \(developerMessage ?? message)"
    }
}

enum RequestableAuthorization {
    case none
    case basic(key: String)
    case oauth(token: String)

    func setAuthorizationHeader(for request: inout URLRequest) {
        let field = "Authorization"
        switch self {
        case .basic(let key):
            request.setValue("Basic \(key)", forHTTPHeaderField: field)
        case .oauth(let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: field)
        case .none:
            break;
        }
    }
}

protocol Requestable {
    associatedtype HttpHeaderParameter: Encodable = Request.NoHeader
    associatedtype QueryParameter: Encodable = Request.NoParameter
    associatedtype Parameter: Encodable = Request.NoParameter
    associatedtype StatusCodes: Sequence where StatusCodes.Iterator.Element == Int
    associatedtype ResponseError: Decodable, Swift.Error, CustomStringConvertible = RequestableGenericResponseError
    associatedtype Path: PathComponentsProvider
    
    static func handler(for configuration: URLSessionConfiguration) -> NetworkHandler
    static var method: Request.Method { get }
    static var cachePolicy: URLRequest.CachePolicy { get }
    static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
    static var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy { get }
    static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
    static var parameterEncoding: Request.ParameterEncoding { get }
    static var timeout: TimeInterval { get }
    static var validStatusCodes: StatusCodes { get }
    static var host: String { get }
    static var authorization: RequestableAuthorization { get }
    static var debug: Bool { get }
}

extension Requestable {
    static var method: Request.Method {
        return .get
    }
    
    static var debug: Bool {
        return _isDebugAssertConfiguration()
    }
    
    static var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    static func handler(for configuration: URLSessionConfiguration) -> NetworkHandler {
        return DependencyMap.networkHandlerProvider.makeSession(configuration, delegate: nil, delegateQueue: nil)
    }
    
    static var parameterEncoding: Request.ParameterEncoding {
        switch method {
        case .post, .put, .patch, .get:
            return .json
        case .head, .delete:
            return .formURL
        }
    }
    
    static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        return .deferredToDate
    }
    
    static var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        return .deferredToData
    }
    
    static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .useDefaultKeys
    }

    static var timeout: TimeInterval {
        return URLSessionConfiguration.default.timeoutIntervalForResource
    }
    
    static var validStatusCodes: CountableClosedRange<Int> {
        return 200...299
    }
    
    static var authorization: RequestableAuthorization {
        return RequestableAuthorization.none
    }
}
