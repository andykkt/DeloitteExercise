//
//  FlickrModel.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import Foundation

enum Flickr {
    enum Method: String, Encodable {
        case search = "flickr.photos.search"
        case getSizes = "flickr.photos.getSizes"
    }
    
    enum Format: String, Encodable {
        case json = "json"
    }

    enum Extra: String, Encodable {
        case Square = "url_sq"
        case LargeSquare = "url_q"
        case Thumbnail = "url_t"
        case Small = "url_s"
        case Small320 = "url_n"
        case Medium = "url_m"
        case Medium640 = "url_z"
        case Medium800 = "url_c"
        case Large = "url_l"
        case Original = "url_o"
        case OwnerName = "owner_name"
    }
}
