//
//  CachedImage.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import UIKit

class CachedImage {
    // MARK: - Definitions
    
    static let shared = CachedImage()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Public Members
    
    var cache = NSCache<NSString, UIImage>()
    
    func get(key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
