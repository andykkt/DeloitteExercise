//
//  NSError+Identifiable.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

extension NSError: Identifiable {
    public var id: Int { code }
}
