//
//  ResultGetErrorTests.swift
//  CommonsTests
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Commons

class ResultTests: XCTestCase {
    func testGetError_whenThereIsFailurere_urnsError() {
        let undefinedError = UndefinedError()
        let resultSuccess: Result<String, UndefinedError> = .success("Hello")
        let resultFailure: Result<String, UndefinedError> = .failure(undefinedError)
        
        XCTAssertNil(resultSuccess.getError())
        XCTAssertEqual(resultFailure.getError(), undefinedError)
    }
    
    // MARK: - Helpers
    struct UndefinedError: Error, Equatable { }
}
