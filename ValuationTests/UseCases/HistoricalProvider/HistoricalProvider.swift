//
//  HistoricalProvider.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import N26BC

class HistoricalProviderTests: XCTestCase {
    func testRetrieveHistoricalData_returnsErrorForNetworkingErrorInRepository() {
        let expectation = XCTestExpectation(description: "HistoricalProvider")
        let (sut, repository) = makeSUT()
        let networkingError = N26BCError.networking
        repository.result = .failure(networkingError)
        
        sut.retrieveHistoricalData(start: Date(), end: Date(), currency: .euro) { result in
            XCTAssertEqual(result.getError(), networkingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveHistoricalData_returnsErrorForOtherErrorInRepository() {
        let expectation = XCTestExpectation(description: "HistoricalProvider")
        let (sut, repository) = makeSUT()
        let networkingError = N26BCError.networking
        repository.result = .failure(networkingError)
        
        sut.retrieveHistoricalData(start: Date(), end: Date(), currency: .euro) { result in
            XCTAssertEqual(result.getError(), networkingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveHistoricalData_returnsValuationForSuccessInRepository() {
        let expectation = XCTestExpectation(description: "HistoricalProvider")
        let (sut, repository) = makeSUT()
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        repository.result = .success([valuation])
        
        sut.retrieveHistoricalData(start: Date(), end: Date(), currency: .euro) { result in
            XCTAssertEqual(try? result.get(), [valuation])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helpers
    func makeSUT() -> (HistoricalDataProvider, TestingRepository) {
        let repository = TestingRepository()
        let provider = HistoricalDataProvider(repository: repository)
        return (provider, repository)
    }
    
    class TestingRepository: HistoricalDataRepository {
        var url: URL?
        var result: Result<[Valuation], N26BCError> = .failure(.networking)
        
        func getHistoricalData(url: URL?, completion: @escaping (Result<[Valuation], N26BCError>) -> Void) {
            self.url = url
            completion(result)
        }
    }
}
