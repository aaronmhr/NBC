//
//  DateToStringTests.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Networking

class DateToStringTests: XCTestCase {
    func testDateToDate_createsString() {
        let date = "1970-01-01"
        let dateFormat = "YYYY-MM-DD"
        let sut = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(sut.toStringWithFormat(dateFormat), date)
    }
    
    func testDateToDate_createsEmptyStringWithBadFormat() {
        let dateFormat = ""
        let sut = Date(timeIntervalSince1970: 0)
        XCTAssertTrue(sut.toStringWithFormat(dateFormat).isEmpty)
    }
}
