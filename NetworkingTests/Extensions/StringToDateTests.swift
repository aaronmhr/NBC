//
//  StringToDateTests.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Networking

class StringToDateTests: XCTestCase {
    func testStringToDate_createsDate() {
        let date = Date(timeIntervalSince1970: 0)
        let dateFormat = "YYYY-MM-DD"
        let sut = "1970-01-01"
        XCTAssertEqual(sut.toDateWithFormat(dateFormat), date)
    }
    
    func testStringToDate_doesNotCreateDateWithBadFormat() {
        let dateFormat = ""
        let sut = "1970-01-01"
        XCTAssertNil(sut.toDateWithFormat(dateFormat))
    }
    
    func testStringToDate_doesNotCreateDateWithBadString() {
        let dateFormat = "YYYY-MM-DD"
        let sut = ""
        XCTAssertNil(sut.toDateWithFormat(dateFormat))
    }
}
