//
//  DetailInteractorTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Commons
import Networking
import Valuation
@testable import N26BC

class DetailInteractorTests: XCTestCase {
    func testDataIsExecuted_usesTodayProviderIfDateIsToday() {
        let expectation = XCTestExpectation(description: "DetailInteractor")
        let (sut, historicalProvider, todayProvider) = makeSUT()
        
        sut.retrieveData(for: .euro, date: Date()) { result in
            XCTAssertFalse(historicalProvider.isHistoricalDataRetrieved)
            XCTAssertTrue(todayProvider.isTodayDataRetrieved)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDataIsExecuted_usesHistoricalProviderIfDateNotToday() {
        let expectation = XCTestExpectation(description: "DetailInteractor")
        let (sut, historicalProvider, todayProvider) = makeSUT()
        
        sut.retrieveData(for: .euro, date: Date(timeIntervalSinceNow: -100000)) { result in
            XCTAssertTrue(historicalProvider.isHistoricalDataRetrieved)
            XCTAssertFalse(todayProvider.isTodayDataRetrieved)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDataIsExecuted_usesHistoricalProviderAndReturnsFirstValuationOfList() {
        let expectation = XCTestExpectation(description: "DetailInteractor")
        let (sut, historicalProvider, todayProvider) = makeSUT()
        let valuation1 = Valuation(date: Date(timeIntervalSinceNow: -100000), price: 1.0, currency: .euro)
        let valuation2 = Valuation(date: Date(timeIntervalSinceNow: -200000), price: 2.0, currency: .euro)
        historicalProvider.result = .success([valuation1, valuation2])
        
        sut.retrieveData(for: .euro, date: Date(timeIntervalSinceNow: -100000)) { result in
            XCTAssertTrue(historicalProvider.isHistoricalDataRetrieved)
            XCTAssertFalse(todayProvider.isTodayDataRetrieved)
            XCTAssertEqual(try? result.get(), valuation1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDataIsExecuted_usesHistoricalProviderAndReturnsErrorWhenListIsEmpty() {
        let expectation = XCTestExpectation(description: "DetailInteractor")
        let (sut, historicalProvider, todayProvider) = makeSUT()
        let error = N26BCError.other
        historicalProvider.result = .success([])
        
        sut.retrieveData(for: .euro, date: Date(timeIntervalSinceNow: -100000)) { result in
            XCTAssertTrue(historicalProvider.isHistoricalDataRetrieved)
            XCTAssertFalse(todayProvider.isTodayDataRetrieved)
            XCTAssertEqual(result.getError(), error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    
    // MARK: - Helpers
    func makeSUT() -> (DetailInteractor, TestingHistoricalProvider, TestingTodayProvider) {
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        let historicalProvider = TestingHistoricalProvider()
        let todayProvider = TestingTodayProvider()
        let sut = DetailInteractor(
            historicalProvider: historicalProvider,
            todayProvider: todayProvider, valuation: valuation)
        return (sut, historicalProvider, todayProvider)
    }

    final class TestingHistoricalProvider: HistoricalProviderProtocol {
        var result: Result<[Valuation], N26BCError> = .failure(.other)
        var isHistoricalDataRetrieved = false
        
        func retrieveHistoricalData(start: Date, end: Date, currency: Currency, completion: @escaping ResultBlock) {
            isHistoricalDataRetrieved = true
            completion(result)
        }
    }
    
    final class TestingTodayProvider: TodayProviderProtocol {
        var isTodayDataRetrieved = false
        
        func retrieveTodayData(currency: Currency, completion: @escaping ResultBlock) {
            isTodayDataRetrieved = true
            completion(.failure(.other))
        }
    }
}

