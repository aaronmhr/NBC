//
//  StringToDateTests.swift
//  CommonsTests
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Commons

class StringToDateTests: XCTestCase {
    func testStringToDate_createsDate() {
        let date = Date(timeIntervalSince1970: 0)
        let dateFormat = "YYYY-MM-DD"
        let sut = "1970-01-01"
        let dateFoormatter = makeFormatter(dateFormat)
        XCTAssertEqual(sut.toDateWithFormat(dateFoormatter), date)
    }
    
    func testStringToDate_doesNotCreateDateWithBadFormat() {
        let dateFormat = ""
        let sut = "1970-01-01"
        let dateFormatter = makeFormatter(dateFormat)
        XCTAssertNil(sut.toDateWithFormat(dateFormatter))
    }
    
    func testStringToDate_doesNotCreateDateWithBadString() {
        let dateFormat = "YYYY-MM-DD"
        let sut = ""
        let dateFormatter = makeFormatter(dateFormat)
        XCTAssertNil(sut.toDateWithFormat(dateFormatter))
    }
    
    func testOptionalNilToString_createsString() {
        let dateFormat = "YYYY-MM-DD"
        let sut: String? = nil
        let dateFormatter = makeFormatter(dateFormat)
        XCTAssertEqual(sut.toDateWithFormat(dateFormatter), nil)
    }
    
    // MARK: - Helpers
    func makeFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
}
