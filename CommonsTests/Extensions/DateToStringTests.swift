//
//  DateToStringTests.swift
//  CommonsTests
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Commons

class DateToStringTests: XCTestCase {
    func testDateToString_createsString() {
        let date = "1970-01-01"
        let dateFormat = "YYYY-MM-DD"
        let sut = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(sut.toStringWithFormat(dateFormat), date)
    }
    
    func testDateToString_createsEmptyStringWithBadFormat() {
        let dateFormat = ""
        let sut = Date(timeIntervalSince1970: 0)
        XCTAssertTrue(sut.toStringWithFormat(dateFormat).isEmpty)
    }

    func testOptionalDateToString_createsString() {
        let date = "1970-01-01"
        let dateFormat = "YYYY-MM-DD"
        let sut: Date? = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(sut.toStringWithFormat(dateFormat), date)
    }
    
    func testOptionalNilToString_createsString() {
        let dateFormat = "YYYY-MM-DD"
        let sut: Date? = nil
        XCTAssertEqual(sut.toStringWithFormat(dateFormat), nil)
    }
}
