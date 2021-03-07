//
//  Photo.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import Foundation

struct Photo: Decodable, Identifiable {
    let id: String
    let owner: String
    let ownername: String?
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    let urlS: String?
    let heightS: Int?
    let widthS: Int?
    let urlN: String?
    let heightN: Int?
    let widthN: Int?
}
