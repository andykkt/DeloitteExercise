//
//  PhotoModelTests.swift
//  FlickrTests
//
//  Created by Andy Kim on 7/3/21.
//

import XCTest
@testable import Flickr

class PhotoModelTests: XCTestCase {
    func testPhotoModelFromSearchVerify() {
        guard let json = Bundle(for: type(of: self)).url(forResource: "SinglePhotoResponse", withExtension: "json")
        else { return XCTFail("failed to get resource") }
        guard let data = try? Data(contentsOf: json)
        else { return XCTFail("failed to get data") }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let object = try? decoder.decode(Photo.self, from: data)
        else { return XCTFail("Decoding forecast object failed") }
        
        XCTAssertEqual(object.id, "51006215143")
        XCTAssertEqual(object.owner, "28277802@N00")
        XCTAssertEqual(object.secret, "612a207013")
        XCTAssertEqual(object.server, "65535")
        XCTAssertEqual(object.farm, 66)
        XCTAssertEqual(object.title, "One Peet")
        XCTAssertEqual(object.ispublic, 1)
        XCTAssertEqual(object.isfriend, 0)
        XCTAssertNotNil(object.urlN)
        XCTAssertEqual(object.urlN, "https://live.staticflickr.com/65535/51006215143_612a207013_n.jpg")
        XCTAssertNotNil(object.heightN)
        XCTAssertEqual(object.heightN, 320)
        XCTAssertNotNil(object.widthN)
        XCTAssertEqual(object.widthN, 240)
        XCTAssertNotNil(object.urlS)
        XCTAssertEqual(object.urlS, "https://live.staticflickr.com/65535/51006215143_612a207013_m.jpg")
        XCTAssertNotNil(object.heightS)
        XCTAssertEqual(object.heightS, 240)
        XCTAssertNotNil(object.widthS)
        XCTAssertEqual(object.widthS, 180)
    }
}
