//
//  MockNetworkHandlerProvider.swift
//  FlickrTests
//
//  Created by Andy Kim on 7/3/21.
//

import Foundation
@testable import Flickr

struct MockNetworkHandlerProvider: NetworkHandlerProvidable {
    let mockSession: URLSession!
    
    init(_ mockSession: URLSession) {
        self.mockSession = mockSession
    }
    
    func makeSession(_ configuration: URLSessionConfiguration,
                     delegate: URLSessionDelegate?,
                     delegateQueue queue: OperationQueue?) -> NetworkHandler {
        return mockSession
    }
}
