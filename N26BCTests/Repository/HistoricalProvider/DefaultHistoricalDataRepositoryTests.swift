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
    func testGetHistoricalData_whenNoValidBPI_providesError() {
        let historicalResponse = HistoricalResponseModel(bpi: nil, disclaimer: "test1")
        
        let successInput: Result<HistoricalResponseModel, NetworkingError> = .success(historicalResponse)
        
        let (sut, networking, _) = makeSUT()
        let expectedResponse = N26BCError.other
        networking.result = successInput
        
        sut.getHistoricalData(url: nil) { response in
            switch (response)  {
            case .failure(let error):
                XCTAssertEqual(error, expectedResponse)
            default: XCTFail()
            }
        }
    }
    
    func testGetHistoricalData_whenNoValidDataFormat_providesEmptyValuationList() {
        let testingCurrency = Currency.euro
        let historicalResponse = HistoricalResponseModel(bpi: ["": 10.0], disclaimer: "test1")
        
        let successInput: Result<HistoricalResponseModel, NetworkingError> = .success(historicalResponse)
        
        let (sut, networking, mapper) = makeSUT()
        let mappedResponse = mapper.map(response: historicalResponse, for: testingCurrency)
        networking.result = successInput
        
        sut.getHistoricalData(url: nil) { response in
            switch (response, mappedResponse)  {
            case (.success(let successResponse), .success(let mappedResponse)):
                XCTAssertEqual(successResponse, mappedResponse)
            default: XCTFail()
            }
        }
    }
    
    func testGetHistoricalData_whenMoreThanOneValue_providesEqualValuationList() {
        let testingCurrency = Currency.euro
        let historicalResponse = HistoricalResponseModel(
            bpi: ["2019-09-10'T'00:00:00+00:00": 1.0, "2019-09-11'T'00:00:00+00:00": 1.0],
            disclaimer: "test1")
        
        let successInput: Result<HistoricalResponseModel, NetworkingError> = .success(historicalResponse)
        
        let (sut, networking, mapper) = makeSUT()
        let mappedResponse = mapper.map(response: historicalResponse, for: testingCurrency)
        networking.result = successInput
        
        sut.getHistoricalData(url: nil) { response in
            switch (response, mappedResponse)  {
            case (.success(let successResponse), .success(let mappedResponse)):
                XCTAssertEqual(successResponse, mappedResponse)
            default: XCTFail()
            }
        }
    }
    
    func testGetHistoricalData_providesN26BCErrorWhenDependencyReturnsNetworkingError() {
        let error1 = NetworkingError.clientError("Test1")
        let error2 = NetworkingError.couldNotBuildURL
        let error3 = NetworkingError.decodingError
        let error4 = NetworkingError.invalidResponse
        let error5 = NetworkingError.other("Test5")
        let error6 = NetworkingError.serverError("Test6")
        
        let showableError: N26BCError = .networking
        
        [error1, error2, error3, error4, error5, error6].forEach { currentError in
            let successInput: Result<HistoricalResponseModel, NetworkingError> = .failure(currentError)

            let (sut, networking, _) = makeSUT()
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
    func makeSUT() -> (DefaultHistoricalDataRepository, TestingURLSessionClient<HistoricalResponseModel>, HistoricalResponseMapperProtocol) {
        let networking = TestingURLSessionClient<HistoricalResponseModel>()
        let mapper = DefaultHistoricalResponseMapper()
        let repository = DefaultHistoricalDataRepository(networking: networking, mapper: mapper)
        return (repository, networking, mapper)
    }
}
