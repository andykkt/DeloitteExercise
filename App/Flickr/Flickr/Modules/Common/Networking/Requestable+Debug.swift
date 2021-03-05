//
//  Requestable+Debug.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

extension Requestable {
    private static func headerTransform(_ header: [AnyHashable: Any]?) -> String {
        return (header ?? [:]).map { "    \($0): \($1)" }.joined(separator: "\n")
    }

    private static func dataTransform(_ data: Data?) -> String {
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "null"
    }
    
    static func debugYAML(request: URLRequest?) -> String? {
        guard let request = request,
            let method = request.httpMethod,
            let url = request.url
            else { return nil }
        return """
        Request:
          Method: \(method)
          URL: \(url)
          CachePolicy: \(cachePolicy.rawValue)
          Header:
        \(headerTransform(request.allHTTPHeaderFields))
          Body: \(dataTransform(request.httpBody))
        """
    }
    
    static func debugCURL(request: URLRequest?) -> String {
        guard let request = request,
            let httpMethod = request.httpMethod,
            let url = request.url,
            let allHTTPHeaderFields = request.allHTTPHeaderFields
            else { return "" }
        let bodyComponents: [String]
        if let data = request.httpBody.flatMap({ String(data: $0, encoding: .utf8) }) {
            if case .formURL = parameterEncoding {
                bodyComponents = data.split(separator: "&").map { "-F \($0)" }
            } else {
                bodyComponents = ["-d", "'\(data)'"]
            }
        } else {
            bodyComponents = []
        }
        let method = "-X \(httpMethod)"
        let headers = allHTTPHeaderFields.map { "-H '\($0.key): \($0.value)'" }
        return ((["curl", method] + headers + bodyComponents + [url.absoluteString]) as [String])
            .joined(separator: " ")
    }
    
    static func debugYAML(response: URLResponse?, data: Data?) -> String? {
        guard let response = response as? HTTPURLResponse else { return nil }
        return """
        Response:
          Code: \(response.statusCode)
          Header:
        \(headerTransform(response.allHeaderFields))
          Body: \(dataTransform(data))
        """
    }
    
    static func debugYAML(responseError error: RequestableError?) -> String? {
        guard let error = error else { return nil }
        return """
        Response:
          Error: \(error.debugDescription)
        """
    }

    static func debugPrintYAML(request: URLRequest?, response: URLResponse?, received: Data?, error: RequestableError? = nil) {
        guard debug else { return }
        let responseYaml = debugYAML(responseError: error) ?? debugYAML(response: response, data: received)
        let yaml = [debugYAML(request: request), responseYaml]
            .compactMap { $0 }
            .joined(separator: "\n")
        let info = """
        #######################
        ##### Requestable #####
        #######################
        # cURL format:
        # \(debugCURL(request: request))
        #######################
        # YAML format:
        \(yaml)
        #######################
        """
        print("\n\(info)\n")
    }
}
