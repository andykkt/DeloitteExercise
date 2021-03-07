//
//  MainAPI.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import Foundation

enum MainAPI {
    enum Search: Fetchable {
        static let method: Request.Method = .get
        static let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
        static let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
        
        struct Response: Decodable {
            struct Body: Decodable {
                let page: Int
                let pages: Int
                let perpage: Int
                let total: String
                let photo: [Photo]
            }
            
            let photos: Body
            let stat: String
        }
        
        struct QueryParameter: Encodable {
            let text: String
            let perPage: Int
            let page: Int
            let method: Flickr.Method = .search
            let apiKey: String = AppConstants.apiKey
            let format: Flickr.Format = .json
            let nojsoncallback: Int = 1
            let extras: String?
            
            init(text: String, perPage: Int, page: Int, extras: [Flickr.Extra]) {
                self.text = text
                self.perPage = perPage
                self.page = page
                if !extras.isEmpty {
                    self.extras = extras.map { String($0.rawValue) }.joined(separator: ",")
                } else {
                    self.extras = nil
                }
            }
        }
        
        struct Path: PathComponentsProvider {
            var pathComponents: [String] {
                ["services/rest"]
            }
        }
    }
}
