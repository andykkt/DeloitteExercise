//
//  Requestable+Loading.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation
import Combine

typealias RequestableCompletion = (Result<Data, RequestableError>) -> Void

private extension Requestable {
    
    private static func httpHeaderDictionary(data: Data) throws -> [String: String] {
        let decoded = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = decoded as? [String: String] else {
            throw EncodingError.invalidValue(decoded, .init(codingPath: [],
                                                            debugDescription: "Expected to decode Dictionary<String, String> but found a Dictionary<_, _> instead"))
        }
        return dictionary
    }
    
    private static func queryEncode(data: Data) throws -> [URLQueryItem] {
        let decoded = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = decoded as? [String: Any] else {
            throw EncodingError.invalidValue(decoded, .init(codingPath: [],
                                                            debugDescription: "Expected to decode Dictionary<String, _> but found a Dictionary<_, _> instead"))
        }
        return dictionary.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
    }
    
    private static func bodyEncode(parameters: Parameter,
                                   encoder: JSONEncoder) throws -> Either<Data?, [URLQueryItem]>
    {
        switch parameterEncoding {
        case .formURL:
            let decoded = try JSONSerialization.jsonObject(with: encoder.encode(parameters), options: [])
            guard let dictionary = decoded as? [String: Any] else {
                throw EncodingError.invalidValue(decoded,
                                                 .init(codingPath: [], debugDescription: "Expected to decode Dictionary<String, _> but found a Dictionary<_, _> instead"))
            }
            return .right(dictionary.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
        case .json:
            return try .left(encoder.encode(parameters))
        case .xml:
            return .left((parameters as? String)?.data(using: .utf8))
        case let .custom(_, closure):
            return try .left(closure(encoder.encode(parameters)))
        }
    }
    
    static func makeRequest(pathProvider: PathComponentsProvider,
                            parameters: Parameter?,
                            httpHeaderParameters: HttpHeaderParameter?,
                            queryParameters: QueryParameter?) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: host) else {
            throw RequestableError.invalidUrl(urlString: host)
        }
        do {
            var requestBody: Data?
            let encoder = JSONEncoder()
            encoder.dataEncodingStrategy = dataEncodingStrategy
            encoder.dateEncodingStrategy = dateEncodingStrategy
            encoder.keyEncodingStrategy = keyEncodingStrategy
            if let parameters = parameters {
                let encoded = try bodyEncode(parameters: parameters, encoder: encoder)
                switch encoded {
                case let .left(data):
                    requestBody = data
                case let .right(items):
                    var components = URLComponents()
                    components.queryItems = items
                    requestBody = components.percentEncodedQuery?.data(using: .utf8)
                }
            }
            if let queryParameters = queryParameters {
                urlComponents.queryItems = try queryEncode(data: encoder.encode(queryParameters))
            }
            guard let baseUrl = urlComponents.url else {
                throw RequestableError.invalidUrl(urlString: pathProvider.pathComponents.joined(separator: "/"))
            }
            let url = pathProvider.pathComponents.reduce(baseUrl, { $0.appendingPathComponent($1) })
            var request = URLRequest(url: url)
            request.cachePolicy = cachePolicy
            request.httpMethod = method.description
            request.httpBody = requestBody
            if let httpHeaderParameters = httpHeaderParameters {
                let httpDictionary = try httpHeaderDictionary(data: encoder.encode(httpHeaderParameters))
                httpDictionary.forEach { key, value in
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            request.setValue(Request.ParameterEncoding.json.contentType, forHTTPHeaderField: "Accept")
            request.setValue(parameterEncoding.contentType, forHTTPHeaderField: "Content-Type")
            authorization.setAuthorizationHeader(for: &request)
            return request
        } catch let error as EncodingError {
            throw RequestableError.encoding(error: error)
        } catch {
            throw RequestableError.underlying(error: error)
        }
    }

    static func request(pathProvider: PathComponentsProvider,
                         parameters: Parameter?,
                         httpHeaderParameters: HttpHeaderParameter?,
                         queryParameters: QueryParameter?) -> AnyPublisher<Data, RequestableError> {
        
        guard let request = try? makeRequest(pathProvider: pathProvider,
                                             parameters: parameters,
                                             httpHeaderParameters: httpHeaderParameters,
                                             queryParameters: queryParameters)
        else {
            return Fail(error: .invalidUrl(urlString: pathProvider.pathComponents.joined(separator: "/")))
                .eraseToAnyPublisher()
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = timeout
        return handler(for: config).dataTaskPublisher(for: request)
            .tryMap { data, response in
                debugPrintYAML(request: request, response: response, received: data)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RequestableError.nonHTTPResponse
                }
                guard validStatusCodes.contains(httpResponse.statusCode) else {
                    throw RequestableError.statusCode(code: httpResponse.statusCode, response: httpResponse, data: data)
                }
                return data
            }
            .mapError { error in
                .underlying(error: error)
            }
            .eraseToAnyPublisher()
    }
}

extension Requestable {
    static func request(path: Path,
                         parameters: Parameter? = nil,
                         httpHeaderParameters: HttpHeaderParameter? = nil,
                         queryParameters: QueryParameter? = nil) -> AnyPublisher<Data, RequestableError> {
        return request(pathProvider: path,
                        parameters: parameters,
                        httpHeaderParameters: httpHeaderParameters,
                        queryParameters: queryParameters)
    }
}
