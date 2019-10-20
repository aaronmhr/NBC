//
//  BitCoinDeskAPITests.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Commons
import Networking
@testable import Valuation

class BitCoinDeskAPITests: XCTestCase {
    func testURLConstructor_forTodayConstructsTheProperTodayURL() {
        let euroURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/EUR.json")
        let dollarURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/USD.json")
        let poundURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/GBP.json")
        let nonDefinedCurrencyURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
        
        let euroConstructor = BitcoinDeskAPI.today(.euro)
        let dollarConstructor = BitcoinDeskAPI.today(.dollar)
        let poundConstructor = BitcoinDeskAPI.today(.pound)
        let nonDefinedContructor = BitcoinDeskAPI.today(.unknown)
        
        XCTAssertEqual(euroConstructor.url, euroURL)
        XCTAssertEqual(dollarConstructor.url, dollarURL)
        XCTAssertEqual(poundConstructor.url, poundURL)
        XCTAssertEqual(nonDefinedContructor.url, nonDefinedCurrencyURL)
    }
    
    func testURLConstructor_forHistoricalConstructsTheProperHistoricalURL() {
        let start = "2013-09-01"
        let end = "2013-09-05"
        let currency = "EUR"
        let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(start)&end=\(end)&currency=\(currency)")
        let dateFormatter = makeFormatter("yyyy-MM-dd")
        let date1 = start.toDateWithFormat(dateFormatter)!
        let date2 = end.toDateWithFormat(dateFormatter)!
        
        let queries = BitcoinDeskAPI.HistoricalQuery(start: date1, end: date2, currency: .euro)
        let urlConstructor = BitcoinDeskAPI.historical(queries)
        
        XCTAssertEqual(urlConstructor.url, url)
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
