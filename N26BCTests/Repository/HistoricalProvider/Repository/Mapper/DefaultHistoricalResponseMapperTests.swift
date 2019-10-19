//
//  DefaultHistoricalResponseMapperTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Networking
@testable import N26BC

class DefaultHistoricalResponseMapperTests: XCTestCase {
    func testMapError_whenThereIsNetworkingError_returnsN26BCError() {
        let errorList: [NetworkingError] = [.clientError("Test1"), .couldNotBuildURL, .decodingError, .invalidResponse, .other("Test5"), .serverError("Test6")]
        let mappedResponse = N26BCError.networking
        
        let sut = makeSUT()
        
        errorList.forEach { error in
            XCTAssertEqual(sut.map(error: error), mappedResponse)
        }
    }

    func testMapResponse_whenThereIsNilBIP_returnsError() {
        let currencies: [Currency] = [.euro, .dollar, .pound]
        let response = HistoricalResponseModel(bpi: nil, disclaimer: nil)
        let mappedResponse = N26BCError.other
        
        let sut = makeSUT()
        
        currencies.forEach { currency in
            XCTAssertEqual(sut.map(response: response, for: currency).getError(), mappedResponse)
        }
    }
    
    func testMapResponse_returnsValuationList() {
        let dateString = "2019-09-10"
        let date = dateString.toDateWithFormat(BitcoinDeskAPI.defaultDateFormat)!
        let price = 10.0
        let currencies: [Currency] = [.euro, .dollar, .pound]
        let response = HistoricalResponseModel(bpi: [dateString: price], disclaimer: "")
        let sut = makeSUT()
        
        currencies.forEach { currency in
            let resultMapped = try! sut.map(response: response, for: currency).get()
            let valuation = Valuation(date: date, price: price, currency: currency)
            
            XCTAssertEqual(resultMapped, [valuation])
        }
    }

    // MARK: - Helpers
    func makeSUT() -> DefaultHistoricalResponseMapper {
        return DefaultHistoricalResponseMapper()
    }
}
