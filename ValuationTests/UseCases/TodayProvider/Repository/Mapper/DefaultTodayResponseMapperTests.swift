//
//  DefaultTodayResponseMapperTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Networking
@testable import Valuation

class DefaultTodayResponseMapperTests: XCTestCase {
    private enum Testing {
        static let dateString = "2019-10-01T05:10:10+00:00"
        static let nilTimeResponse = TimeResponseModel(updatedISO: nil)
        static let validTimeResponse = TimeResponseModel(updatedISO: dateString)
        static let nilEuroRate = CurrencyResponseModel(code: "EUR", rateFloat: nil)
        static let validEuroRate = CurrencyResponseModel(code: "EUR", rateFloat: 10.0)
        static let nilDollarRate = CurrencyResponseModel(code: "USD", rateFloat: nil)
        static let validDollarRate = CurrencyResponseModel(code: "USD", rateFloat: 5.0)
        static let nilPoundRate = CurrencyResponseModel(code: "GBP", rateFloat: nil)
        static let validPoundRate = CurrencyResponseModel(code: "GBP", rateFloat: 15.0)
    }
    
    func testMapError_whenThereIsNetworkingError_returnsBCError() {
        let errorList: [NetworkingError] = [.clientError("Test1"), .couldNotBuildURL, .decodingError, .invalidResponse, .other("Test5"), .serverError("Test6")]
        let mappedResponse = BCError.networking
        
        let sut = makeSUT()
        
        errorList.forEach { error in
            XCTAssertEqual(sut.map(error: error), mappedResponse)
        }
    }
    
    func testMapResponse_whenTimeIsNil_providesError() {
        let currencies: [Currency] = [.euro, .dollar, .pound, .unknown]
        let sut = makeSUT()
        let expectedResponse = BCError.other
        
        currencies.forEach { currency in
            let bpi = BpiResponseModel(usd: Testing.validDollarRate, gbp: Testing.validPoundRate, eur: Testing.validEuroRate)
            let today = TodayResponseModel(time: nil, bpi: bpi)
            let result = sut.map(response: today, for: currency)
            
            XCTAssertEqual(result.getError(), expectedResponse)
        }
    }
    
    func testMapResponse_whenBPIForSelectedCurrencyIsNil_returnsError() {
        let currencies: [Currency] = [.euro, .dollar, .pound, .unknown]
        let sut = makeSUT()
        let expectedResponse = BCError.other
        
        currencies.forEach { currency in
            let bpi = BpiResponseModel(usd: Testing.nilDollarRate, gbp: Testing.nilPoundRate, eur: Testing.nilEuroRate)
            let today = TodayResponseModel(time: Testing.validTimeResponse, bpi: bpi)
            let result = sut.map(response: today, for: currency)
            XCTAssertEqual(result.getError(), expectedResponse)
        }
    }
    
    func testMapResponse_whenBPIIsValidTestingForCurrency_returnsNonNilSuccessForThatCurrency() {
        let currencies: [Currency] = [.euro, .dollar, .pound, .unknown]
        let selectedCurrency = Currency.dollar
        let sut = makeSUT()
        
        let date = Testing.dateString.toDateWithFormat(BitcoinDeskAPI.todayFormatter)!
        let expectedResult: Result<Valuation, BCError> = .success(Valuation(date: date, price: 5.0, currency: selectedCurrency))
        
        currencies.forEach { currency in
            let bpi = BpiResponseModel(usd: Testing.validDollarRate, gbp: Testing.nilPoundRate, eur: Testing.nilEuroRate)
            let today = TodayResponseModel(time: Testing.validTimeResponse, bpi: bpi)
            let result = sut.map(response: today, for: currency)
            
            switch currency {
            case .dollar:
                XCTAssertEqual(result, expectedResult)
            default:
                XCTAssertNotNil(result.getError())
            }
        }
    }
    
    // MARK: - Helpers
    func makeSUT() -> DefaultTodayResponseMapper {
        return DefaultTodayResponseMapper()
    }
}
