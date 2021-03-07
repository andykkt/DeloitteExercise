//
//  MainAPITests.swift
//  FlickrTests
//
//  Created by Andy Kim on 7/3/21.
//

import XCTest
import Combine
@testable import Flickr

class MainAPITests: XCTestCase {
    
    private let invalidResponse = URLResponse(url: URL(string: "http://localhost:8080")!,
                                      mimeType: nil,
                                      expectedContentLength: 0,
                                      textEncodingName: nil)
    
    private let validResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)
    
    private let invalidResponse300 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 300,
                                           httpVersion: nil,
                                           headerFields: nil)
    private let invalidResponse401 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 401,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    private let networkError = NSError(domain: "NSURLErrorDomain",
                               code: -1004, //kCFURLErrorCannotConnectToHost
                               userInfo: nil)
    
    private var disposables = Set<AnyCancellable>()
    
    func testValidSearchResponse() throws {
        let expectation = XCTestExpectation(description: "MainAPI.Search.fetch Request")
        
        guard let json = Bundle(for: type(of: self)).url(forResource: "SearchResponse", withExtension: "json"),
            let data = try? Data(contentsOf: json)
        else { return XCTFail("shouldn't fail") }
        
        let url = URL(string: "https://api.flickr.com/services/rest")!
        URLProtocolMock.testURLs = [url: data]
        URLProtocolMock.response = validResponse

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: config)
        DependencyMap.networkHandlerProvider = MockNetworkHandlerProvider(session)
        
        MainAPI.Search.fetch(path: .init())
            .mapError { error in
                DataError.network(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .failure(let error):
                    print("error: \(error)")
                    XCTFail("shouldn't fail")
                    expectation.fulfill()
                case .finished:
                    break
                }
            } receiveValue: { response in
                XCTAssertEqual(response.stat, "ok")
                XCTAssertEqual(response.photos.page, 21)
                XCTAssertEqual(response.photos.pages, 8187)
                XCTAssertEqual(response.photos.perpage, 50)
                XCTAssertEqual(response.photos.total, "409302")
                XCTAssertEqual(response.photos.photo.count, 50)

                guard let object = response.photos.photo.first
                else { return XCTFail("Failed to get first object") }
                
                XCTAssertEqual(object.id, "51008667108")
                XCTAssertEqual(object.owner, "136863444@N08")
                XCTAssertEqual(object.secret, "1d9bec3540")
                XCTAssertEqual(object.server, "65535")
                XCTAssertEqual(object.farm, 66)
                XCTAssertEqual(object.title, "HOFI DSC00613")
                XCTAssertEqual(object.ispublic, 1)
                XCTAssertEqual(object.isfriend, 0)
                XCTAssertEqual(object.isfamily, 0)
                XCTAssertEqual(object.ownername, "clausholzapfel")
                XCTAssertNotNil(object.urlN)
                XCTAssertEqual(object.urlN, "https://live.staticflickr.com/65535/51008667108_1d9bec3540_n.jpg")
                XCTAssertNotNil(object.heightN)
                XCTAssertEqual(object.heightN, 225)
                XCTAssertNotNil(object.widthN)
                XCTAssertEqual(object.widthN, 320)
                XCTAssertNotNil(object.urlS)
                XCTAssertEqual(object.urlS, "https://live.staticflickr.com/65535/51008667108_1d9bec3540_m.jpg")
                XCTAssertNotNil(object.heightS)
                XCTAssertEqual(object.heightS, 169)
                XCTAssertNotNil(object.widthS)
                XCTAssertEqual(object.widthS, 240)
                
                expectation.fulfill()
            }
            .store(in: &disposables)
            
        // THEN: Continue
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInValidSearchResponse() throws {
        let expectation = XCTestExpectation(description: "MainAPI.Search.fetch Request")

        URLProtocolMock.response = invalidResponse
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: config)
        DependencyMap.networkHandlerProvider = MockNetworkHandlerProvider(session)
        
        MainAPI.Search.fetch(path: .init())
            .mapError { error in
                DataError.network(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .failure(let error):
                    print("error: \(error)")
                    expectation.fulfill()
                case .finished:
                    XCTFail("shouldn't finish from invalid response")
                    expectation.fulfill()
                    break
                }
            } receiveValue: { response in
                XCTFail("shouldn't get response from invalid response")
                expectation.fulfill()
            }
            .store(in: &disposables)
            
        // THEN: Continue
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInvalidResponse300SearchResponse() throws {
        let expectation = XCTestExpectation(description: "MainAPI.Search.fetch Request")
        
        URLProtocolMock.response = invalidResponse300
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: config)
        DependencyMap.networkHandlerProvider = MockNetworkHandlerProvider(session)
        
        MainAPI.Search.fetch(path: .init())
            .mapError { error in
                DataError.network(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .failure(let error):
                    print("error: \(error)")
                    expectation.fulfill()
                case .finished:
                    XCTFail("shouldn't finish from invalid response")
                    expectation.fulfill()
                    break
                }
            } receiveValue: { response in
                XCTFail("shouldn't get response from invalid response")
                expectation.fulfill()
            }
            .store(in: &disposables)
            
        // THEN: Continue
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInvalidResponse401SearchResponse() throws {
        let expectation = XCTestExpectation(description: "MainAPI.Search.fetch Request")
        
        URLProtocolMock.response = invalidResponse401
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: config)
        DependencyMap.networkHandlerProvider = MockNetworkHandlerProvider(session)
        
        MainAPI.Search.fetch(path: .init())
            .mapError { error in
                DataError.network(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .failure(let error):
                    print("error: \(error)")
                    expectation.fulfill()
                case .finished:
                    XCTFail("shouldn't finish from invalid response")
                    expectation.fulfill()
                    break
                }
            } receiveValue: { response in
                XCTFail("shouldn't get response from invalid response")
                expectation.fulfill()
            }
            .store(in: &disposables)
            
        // THEN: Continue
        wait(for: [expectation], timeout: 10.0)
    }
}
