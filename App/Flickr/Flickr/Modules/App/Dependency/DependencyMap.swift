//
//  DependencyMap.swift
//  Flickr
//
//  Created by Andy Kim on 7/3/21.
//

import Foundation

enum DependencyMap {
    static var dataProvider: DataProvidable = NetworkDataProvider()
    static var networkHandlerProvider: NetworkHandlerProvidable = DefaultNetworkHandlerProvider()
}

protocol NetworkHandlerProvidable {
    func makeSession(_ configuration: URLSessionConfiguration,
                     delegate: URLSessionDelegate?,
                     delegateQueue queue: OperationQueue?) -> NetworkHandler
}
