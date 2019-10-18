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
    
    func testGetHistoricalData_providesShowableErrorWhenDependencyReturnsNetworkingError() {
        let error1 = NetworkingError.clientError("Test1")
        let error2 = NetworkingError.couldNotBuildURL
        let error3 = NetworkingError.decodingError
        let error4 = NetworkingError.invalidResponse
        let error5 = NetworkingError.other("Test5")
        let error6 = NetworkingError.serverError("Test6")
        
        let showableError: ShowableError = .networking
        
        [error1, error2, error3, error4, error5, error6].forEach { currentError in
            let successInput: Result<HistoricalResponseModel, NetworkingError> = .failure(currentError)

            let (sut, networking) = makeSUT()
            networking.result = successInput
            
            sut.getHistoricalData(url: nil) { response in
                switch response {
                case .success: XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error, showableError)
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
