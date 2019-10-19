//
//  DefaultTodayDataRepositoryTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 18/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

import XCTest
import Networking
@testable import N26BC

class DefaultTodayDataRepositoryTests: XCTestCase {
    func testGetTodayData_providesTodayData() {
        let response1 = givenTodayResponseModel(withRate: 1000.0)
        let response2 = givenTodayResponseModel(withRate: 2000.0)
        
        
        [response1, response2].forEach { currentResponse in
            let successInput: Result<TodayResponseModel, NetworkingError> = .success(currentResponse)

            let (sut, networking, mapper) = makeSUT()
            let expectedResponse = try! mapper.map(response: currentResponse, for: .euro).get()
            networking.result = successInput
            
            sut.getTodayData(url: nil) { response in
                switch response {
                case .success(let successResponse):
                    XCTAssertEqual(successResponse.currency, expectedResponse.currency)
                    XCTAssertEqual(successResponse.price, expectedResponse.price)
                default: XCTFail()
                }
            }
        }
    }
    
    func testGetTodayData_providesShowableErrorWhenDependencyReturnsNetworkingError() {
        let error1 = NetworkingError.clientError("Test1")
        let error2 = NetworkingError.couldNotBuildURL
        let error3 = NetworkingError.decodingError
        let error4 = NetworkingError.invalidResponse
        let error5 = NetworkingError.other("Test5")
        let error6 = NetworkingError.serverError("Test6")
        
        let showableError: N26BCError = .networking
        
        [error1, error2, error3, error4, error5, error6].forEach { currentError in
            let successInput: Result<TodayResponseModel, NetworkingError> = .failure(currentError)

            let (sut, networking, _) = makeSUT()
            networking.result = successInput
            
            sut.getTodayData(url: nil) { response in
                switch response {
                case .success: XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error, showableError)
                }
            }
        }
    }
    
    // MARK: - Helpers
    func makeSUT() -> (DefaultTodayDataRepository, TestingURLSessionClient<TodayResponseModel>, CurrentResponseMapperProtocol) {
        let networking = TestingURLSessionClient<TodayResponseModel>()
        let mapper = DefaultCurrentResponseMapper()
        let repository = DefaultTodayDataRepository(networking: networking, mapper: mapper)
        return (repository, networking, mapper)
    }
    
    private func givenTodayResponseModel(withRate rate: Double) -> TodayResponseModel {
        let time = TimeResponseModel(updatedISO: "2019-09-10'T'00:00:00+00:00")
        let currency = CurrencyResponseModel(code: "EUR", rateFloat: rate)
        let bpi = BpiResponseModel(usd: nil, gbp: nil, eur: currency)
        let todayResponse = TodayResponseModel(time: time, bpi: bpi)
        return todayResponse
    }
}
