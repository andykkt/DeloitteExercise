//
//  PathComponentsProvider.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

protocol PathComponentsProvider {
    var pathComponents: [String] { get }
}

extension String: PathComponentsProvider {
    var pathComponents: [String] {
        return components(separatedBy: "/").filter { !$0.isEmpty }
    }
}

extension Array: PathComponentsProvider {
    var pathComponents: [String] {
        return map(String.init(describing:))
    }
}
