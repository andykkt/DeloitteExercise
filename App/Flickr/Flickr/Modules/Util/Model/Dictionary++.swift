//
//  Dictionary++.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

extension Dictionary {
    subscript(firstNonNil keys: Key...) -> Value? {
        return keys.firstNonNil { self[$0] }
    }

    func filterValues(_ isIncluded: (Value) throws -> Bool) rethrows -> Dictionary {
        return try filter { try isIncluded($0.value) }
    }
}
