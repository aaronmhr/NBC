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
    func testGetHistoricalData_ProvidesTodayData() {
        let historicalResponse = HistoricalResponseModel(bpi: nil, disclaimer: "test1")
        let successInput: Result<HistoricalResponseModel, NetworkingError> = .success(historicalResponse)
        let expectedResponse = N26BCError.other
        
        let (sut, networking, mapper) = makeSUT()
        networking.result = successInput
        mapper.errorOutput = expectedResponse
        
        sut.getHistoricalData(url: nil) { response in
            XCTAssertEqual(mapper.successInput, try? networking.result?.get(), "Mapper success input is networking succes result")
            XCTAssertEqual(response, mapper.resultOutput)
        }
    }
    
    func testGetHistoricalData_providesN26BCErrorWhenDependencyReturnsNetworkingError() {
        let error1 = NetworkingError.clientError("Test1")
        let error2 = NetworkingError.couldNotBuildURL
        let error3 = NetworkingError.decodingError
        let error4 = NetworkingError.invalidResponse
        let error5 = NetworkingError.other("Test5")
        let error6 = NetworkingError.serverError("Test6")
        
        [error1, error2, error3, error4, error5, error6].forEach { currentError in
            let successInput: Result<HistoricalResponseModel, NetworkingError> = .failure(currentError)

            let (sut, networking, mapper) = makeSUT()
            networking.result = successInput
            
            sut.getHistoricalData(url: nil) { response in
                XCTAssertEqual(mapper.errorInput, currentError)
                XCTAssertEqual(response.getError(), mapper.errorOutput)
            }
        }
    }
    
    // MARK: - Helpers
    func makeSUT() -> (DefaultHistoricalDataRepository, TestingURLSessionClient<HistoricalResponseModel>, TestingMapper) {
        let networking = TestingURLSessionClient<HistoricalResponseModel>()
        let mapper = TestingMapper()
        let repository = DefaultHistoricalDataRepository(networking: networking, mapper: mapper)
        return (repository, networking, mapper)
    }
    
    class TestingMapper: HistoricalResponseMapperProtocol {
        var successInput: HistoricalResponseModel?
        var errorInput: NetworkingError?
        
        var resultOutput: Result<[Valuation], N26BCError> = .failure(.other)
        var errorOutput: N26BCError = .other
        
        func map(response: HistoricalResponseModel, for currency: Currency) -> Result<[Valuation], N26BCError> {
            successInput = response
            return resultOutput
        }
        
        func map(error: NetworkingError) -> N26BCError {
            errorInput = error
            return errorOutput
        }
    }
}
