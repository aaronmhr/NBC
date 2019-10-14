//
//  URLSessionExtensionsTest.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 14/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Networking

class URLSessionExtensionTests: XCTestCase {
    func testDataTask_returnsErrorAtIncompleteURL() {
        let session = makeSUT()
        let expectation = XCTestExpectation(description: "Try incomplete URL")
        let url = URL(string: "https://google")!
        
        let dataTask = session.dataTask(with: url) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                assertionFailure()
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDataTask_returnsErrorAtRandomURL() {
        let session = makeSUT()
        let expectation = XCTestExpectation(description: "Try random URL")
        let url = URL(string: "https://gggggggggggggggggggggggg123123.com")!
        
        let dataTask = session.dataTask(with: url) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                assertionFailure()
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDataTaskSuccedsWhen_validURLIsProvided() {
                let session = makeSUT()
        let expectation = XCTestExpectation(description: "Try random URL")
        let url = URL(string: "https://google.com")!
        
        let dataTask = session.dataTask(with: url) { (result) in
            switch result {
            case .failure:
                assertionFailure()
            case let .success(response, data):
                XCTAssertNotNil(response)
                XCTAssertNotNil(data)
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - Helpers
    func makeSUT() -> URLSession {
        return URLSession(configuration: .ephemeral)
    }
}
