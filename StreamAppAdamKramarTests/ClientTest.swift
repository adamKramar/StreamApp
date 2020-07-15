//
//  ClientTest.swift
//  StreamAppAdamKramarTests
//
//  Created by Adam Kramar on 15/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

@testable import StreamAppAdamKramar
import XCTest

class ClientTest: XCTestCase {
    
    var client: Client!
    
    override func setUp() {
        super.setUp()
        client = Client()
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }

    func test_request_with_JSON_response() {
        let url = "\(K.Api.apiUrl)popular\(K.Api.apiKey)"
        client.performRequestWithJSONResponse(with: url) { (error, data) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
        }
    }
    
    func test_request_with_Image_response() {
        let posterPath = "/cjr4NWURcVN3gW5FlHeabgBHLrY.jpg"
        let url = "\(K.Api.imgPath)\(posterPath)"
        client.performRequestWithImageResponse(with: url) { (error, data) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
        }
        
    }

}
