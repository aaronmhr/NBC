//
//  DefaultHistoricalDataRepositoryTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Networking
@testable import N26BC

class DefaultHistoricalDataRepositoryTests: XCTestCase {
    func testGetHistoricalData_providesHistoricalData() {
        let historicalResponse1 = HistoricalResponseModel(bpi: nil, disclaimer: "test1")
        let historicalResponse2 = HistoricalResponseModel(bpi: nil, disclaimer: "test2")
        
        [historicalResponse1, historicalResponse2].forEach { currentResponse in
            let successInput: Result<HistoricalResponseModel, NetworkingError> = .success(currentResponse)

            let (sut, networking) = makeSUT()
            networking.result = successInput
            
            sut.getHistoricalData(url: nil) { response in
                switch response {
                case .success(let successResponse):
                    XCTAssertEqual(successResponse, currentResponse)
                default: XCTFail()
                }
            }
        }
    }
    
    // MARK: - Helpers
    func makeSUT() -> (DefaultHistoricalDataRepository, TestingURLSessionClient) {
        let networking = TestingURLSessionClient()
        let repository = DefaultHistoricalDataRepository(networking: networking)
        return (repository, networking)
    }
    
    final class TestingURLSessionClient: URLSessionClientProtocol {
        var result: Result<HistoricalResponseModel, NetworkingError>?
        
        func fetchResources<T: Decodable>(url: URL?, completion: @escaping (Result<T, NetworkingError>) -> Void) {
            guard let result = self.result as? Result<T, NetworkingError> else {
                XCTFail()
                return
            }
            completion(result)
        }
    }
}
