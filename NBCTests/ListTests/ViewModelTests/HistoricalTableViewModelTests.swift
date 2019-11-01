//
//  HistoricalTableViewModelTests.swift
//  NBCTests
//
//  Created by Aaron Huánuco on 01/11/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Valuation
@testable import NBC

class HistoricalTableViewModelTests: XCTestCase {
    func testMakeSection_formatsCorrectlyDatesAndPrices() {
        let currencies: [Currency] = [.euro , .dollar, .pound]
        let inputStringDate = "01/10/2019"
        let inputDate = inputStringDate.toDateWithFormat(dateFormatter)!
        let inputPrice = 10.0
        let inputTitle = "Historical"
        
        let expectedDateOutput = "10-01-2019"
        let expectedPriceOutput = ["1BTC = 10.0 EUR", "1BTC = 10.0 USD", "1BTC = 10.0 GBP"]
        let expectedTitleOutput = "Historical"
        
        zip(currencies, expectedPriceOutput).forEach { (currency: Currency, priceOutput: String) in
            let valuation = Valuation(date: inputDate, price: inputPrice, currency: currency)
            let historicalViewModel = HistoricalTableViewModel.makeSectionViewModel(from: [valuation], title: inputTitle)
            
            XCTAssertEqual(historicalViewModel.title, expectedTitleOutput)
            XCTAssertEqual(historicalViewModel.rows[0].date, expectedDateOutput)
            XCTAssertEqual(historicalViewModel.rows[0].price, priceOutput)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier:"GMT")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
}
