//
//  DefaultNetworkHandlerProvider.swift
//  Flickr
//
//  Created by Andy Kim on 7/3/21.
//

import Foundation

struct DefaultNetworkHandlerProvider: NetworkHandlerProvidable {
    func makeSession(_ configuration: URLSessionConfiguration,
                     delegate: URLSessionDelegate?,
                     delegateQueue queue: OperationQueue?) -> NetworkHandler {
        URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
}
