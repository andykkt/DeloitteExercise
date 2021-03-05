//
//  NetworkHandler.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//
import Foundation

protocol NetworkHandler {
    init(configuration: URLSessionConfiguration)
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkHandler {}
