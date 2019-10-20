//
//  ListInteractorTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Commons
import Networking
import Valuation
@testable import N26BC

class ListInteractorTests: XCTestCase {
    func testRetrieveHistoricalDataIsExecutedPropperly() {
        let expectation = XCTestExpectation(description: "ListInteractor")
        let (sut, historicalProvider, _, sorter, _) = makeSUT()
        
        sut.retrieveHistoricalData { result in
            XCTAssertTrue(historicalProvider.isHistoricalDataRetrieved)
            XCTAssertTrue(sorter.isSorted)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveTodayDataIsExecutedProperly() {
        let expectation = XCTestExpectation(description: "ListInteractor")
        let (sut, _, todayProvider, _, timer) = makeSUT()
        
        sut.retrieveTodayData { result in
            XCTAssertTrue(timer.isScheduled)
            XCTAssertTrue(timer.isRepeating)
            XCTAssertTrue(todayProvider.isTodayDataRetrieved)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(timer.isFired)
        XCTAssertFalse(timer.isInvalidated)
    }
    
    func testStopRetreavingTodayData() {
        let (sut, _, _, _, timer) = makeSUT()
        
        sut.stopRetreavingTodayData()
        
        XCTAssertTrue(timer.isInvalidated)
    }
    
    // MARK: - Helpers
    func makeSUT() -> (ListInteractor, TestingHistoricalProvider, TestingTodayProvider, TestingValuationSorter, TestingTimer) {
        let historicalProvider = TestingHistoricalProvider()
        let todayProvider = TestingTodayProvider()
        let valuationSorter = TestingValuationSorter()
        let timer = TestingTimer()
        let sut = ListInteractor(
            historicalProvider: historicalProvider,
            todayProvider: todayProvider,
            valuationSorter: valuationSorter,
            timer: timer)
        return (sut, historicalProvider, todayProvider, valuationSorter, timer)
    }

    final class TestingHistoricalProvider: HistoricalProviderProtocol {
        var isHistoricalDataRetrieved = false
        
        func retrieveHistoricalData(start: Date, end: Date, currency: Currency, completion: @escaping ResultBlock) {
            isHistoricalDataRetrieved = true
            completion(.failure(.other))
        }
    }
    
    final class TestingTodayProvider: TodayProviderProtocol {
        var isTodayDataRetrieved = false
        
        func retrieveTodayData(currency: Currency, completion: @escaping ResultBlock) {
            isTodayDataRetrieved = true
            completion(.failure(.other))
        }
    }
    
    final class TestingValuationSorter: ValuationSorterProtocol {
        var isSorted = false
        
        func sort(_ items: Result<[Valuation], N26BCError>) -> Result<[Valuation], N26BCError> {
            isSorted = true
            return items
        }
    }
    
    final class TestingTimer: TimerProtocol {
        var isFired = false
        var isInvalidated = false
        var isScheduled = false
        var isRepeating = false
        
        func fire() {
            isFired = true
        }
        
        func invalidate() {
            isInvalidated = true
        }
        
        func schedule(timeInterval: TimeInterval, repeats: Bool, completionBlock: @escaping CompletionBlock) {
            isRepeating = repeats
            isScheduled = true
            completionBlock()
        }
    }
}
