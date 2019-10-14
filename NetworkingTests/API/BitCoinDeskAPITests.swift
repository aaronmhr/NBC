//
//  BitCoinDeskAPITests.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Networking

class BitCoinDeskAPITests: XCTestCase {
    func testURLConstructor_forTodayConstructsTheProperTodayURL() {
        let euroURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/EUR.json")
        let dollarURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/USD.json")
        let poundURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/GBP.json")
        
        let euroConstructor = BitcoinDeskAPI.today(.euro)
        let dollarConstructor = BitcoinDeskAPI.today(.dollar)
        let poundConstructor = BitcoinDeskAPI.today(.pound)
        
        XCTAssertEqual(euroConstructor.url, euroURL)
        XCTAssertEqual(dollarConstructor.url, dollarURL)
        XCTAssertEqual(poundConstructor.url, poundURL)
    }
    
    func testURLConstructor_forHistoricalConstructsTheProperHistoricalURL() {
        let start = "2013-09-01"
        let end = "2013-09-05"
        let currency = "EUR"
        let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(start)&end=\(end)&currency=\(currency)")
        
        let date1 = start.toDateWithFormat("yyyy-MM-dd")!
        let date2 = end.toDateWithFormat("yyyy-MM-dd")!
        
        let queries = BitcoinDeskAPI.HistoricalQuery(start: date1, end: date2, currency: .euro)
        let urlConstructor = BitcoinDeskAPI.historical(queries)
        
        XCTAssertEqual(urlConstructor.url, url)
    }
}
