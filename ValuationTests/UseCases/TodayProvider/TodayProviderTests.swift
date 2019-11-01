//
//  TodayProviderTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Valuation

class TodayProviderTests: XCTestCase {
    func testRetrieveTodayData_returnsErrorForNetworkingErrorInRepository() {
        let expectation = XCTestExpectation(description: "TodayProvider")
        let (sut, repository) = makeSUT()
        let networkingError = BCError.networking
        repository.result = .failure(networkingError)
        
        sut.retrieveTodayData(currency: .euro) { result in
            XCTAssertEqual(result.getError(), networkingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveTodayData_returnsErrorForOtherErrorInRepository() {
        let expectation = XCTestExpectation(description: "TodayProvider")
        let (sut, repository) = makeSUT()
        let networkingError = BCError.networking
        repository.result = .failure(networkingError)
        
        sut.retrieveTodayData(currency: .euro) { result in
            XCTAssertEqual(result.getError(), networkingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveTodayData_returnsValuationForSuccessInRepository() {
        let expectation = XCTestExpectation(description: "TodayProvider")
        let (sut, repository) = makeSUT()
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        repository.result = .success(valuation)
        
        sut.retrieveTodayData(currency: .euro) { result in
            XCTAssertEqual(try? result.get(), valuation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helpers
    func makeSUT() -> (TodayDataProvider, TestingRepository) {
        let repository = TestingRepository()
        let provider = TodayDataProvider(repository: repository)
        return (provider, repository)
    }
    
    class TestingRepository: TodayDataRepository {
        var url: URL?
        var result: Result<Valuation, BCError> = .failure(.networking)
        
        func getTodayData(url: URL?, currency: Currency, completion: @escaping (Result<Valuation, BCError>) -> Void) {
            self.url = url
            completion(result)
        }
    }
}
