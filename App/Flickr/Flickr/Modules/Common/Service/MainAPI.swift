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
        
        struct Response: Decodable {
            struct Body: Decodable {
                let page: Int
                let pages: Int
                let total: Int
                let photo: [Photo]
            }
            
            let photos: Body
            let stat: String
        }
        
        struct QueryParameter: Encodable {
            let text: String
            let perPage: Int
            let method: Flickr.Method = .search
            let apiKey: String = AppConstants.apiKey
            let format: Flickr.Format = .json
            let nojsoncallback: Int = 1
            let extras: [Flickr.Extra] = [.Small320]
        }
        
        struct Path: PathComponentsProvider {
            var pathComponents: [String] {
                ["services/rest"]
            }
        }
    }
}
