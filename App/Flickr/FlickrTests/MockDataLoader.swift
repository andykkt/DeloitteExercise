//
//  MockDataLoader.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import Foundation

struct MockDataLoader<T: Decodable> {
    let data: T
    
    init(fileName: String, decoder: JSONDecoder = JSONDecoder()) {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                self.data = try decoder.decode(T.self, from: jsonData)
            } else {
                fatalError("Couldn't get PreviewData from file")
            }
        } catch {
            fatalError("Couldn't get PreviewData from file due to an error: \(error)")
        }
    }
}
