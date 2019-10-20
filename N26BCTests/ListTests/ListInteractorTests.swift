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
@testable import N26BC

class ListInteractorTests: XCTestCase {
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testRetrieveTodayDataIsExecuted() {
        let expectation = XCTestExpectation(description: "ListInteractor")
        let (sut, _, todayProvider, _, timer) = makeSUT()
        
        sut.retrieveTodayData { result in
            XCTAssertTrue(timer.isScheduled)
            XCTAssertTrue(timer.isRepeating)
            XCTAssertTrue(todayProvider.isTodayRetrieved)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(timer.isFired)
        XCTAssertFalse(timer.isInvalidated)
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
        var isHistoricalRetrieved = false
        
        func retrieveHistoricalData(start: Date, end: Date, currency: Currency, completion: @escaping ResultBlock) {
            isHistoricalRetrieved = true
            completion(.failure(.other))
        }
    }
    
    final class TestingTodayProvider: TodayProviderProtocol {
        var isTodayRetrieved = false
        
        func retrieveTodayData(currency: Currency, completion: @escaping ResultBlock) {
            isTodayRetrieved = true
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
