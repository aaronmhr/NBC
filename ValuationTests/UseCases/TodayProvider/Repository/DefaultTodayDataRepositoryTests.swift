//
//  DefaultTodayDataRepositoryTests.swift
//  NBCTests
//
//  Created by Aaron Huánuco on 18/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

import XCTest
import Networking
@testable import Valuation

class DefaultTodayDataRepositoryTests: XCTestCase {
    func testGetTodayData_providesTodayData() {
        let response1 = givenTodayResponseModel(withRate: 1000.0)
        let response2 = givenTodayResponseModel(withRate: 2000.0)
        let currency = Currency.euro
        [response1, response2].forEach { currentResponse in
            let successInput: Result<TodayResponseModel, NetworkingError> = .success(currentResponse)
            let successOutput: Result<Valuation, BCError> = .success(Valuation(date: Date(), price: 10, currency: currency))

            let (sut, networking, mapper) = makeSUT()
            networking.result = successInput
            mapper.resultOutput = successOutput

            sut.getTodayData(url: nil, currency: currency) { response in
                XCTAssertEqual(mapper.successInput, try? networking.result?.get(), "Mapper success input is networking succes result")
                XCTAssertEqual(response, mapper.resultOutput)
            }
        }
    }
    
    func testGetTodayData_providesErrorWhenDependencyReturnsNetworkingError() {
        let error1 = NetworkingError.clientError("Test1")
        let error2 = NetworkingError.couldNotBuildURL
        let error3 = NetworkingError.decodingError
        let error4 = NetworkingError.invalidResponse
        let error5 = NetworkingError.other("Test5")
        let error6 = NetworkingError.serverError("Test6")
        let currency = Currency.euro

        [error1, error2, error3, error4, error5, error6].forEach { currentError in
            let successInput: Result<TodayResponseModel, NetworkingError> = .failure(currentError)

            let (sut, networking, mapper) = makeSUT()
            networking.result = successInput

            sut.getTodayData(url: nil, currency: currency) { response in
                XCTAssertEqual(mapper.errorInput, currentError)
                XCTAssertEqual(response.getError(), mapper.errorOutput)
            }
        }
    }
    
    // MARK: - Helpers
    func makeSUT() -> (DefaultTodayDataRepository, TestingURLSessionClient<TodayResponseModel>, TestingMapper) {
        let networking = TestingURLSessionClient<TodayResponseModel>()
        let mapper = TestingMapper()
        let repository = DefaultTodayDataRepository(networking: networking, mapper: mapper)
        return (repository, networking, mapper)
    }
    
    class TestingMapper: TodayResponseMapperProtocol {
        var successInput: TodayResponseModel?
        var errorInput: NetworkingError?
        
        var resultOutput: Result<Valuation, BCError> = .failure(.other)
        var errorOutput: BCError = .other
        
        func map(response: TodayResponseModel, for currency: Currency) -> Result<Valuation, BCError> {
            successInput = response
            return resultOutput
        }
        
        func map(error: NetworkingError) -> BCError {
            errorInput = error
            return errorOutput
        }
    }
    
    private func givenTodayResponseModel(withRate rate: Double) -> TodayResponseModel {
        let time = TimeResponseModel(updatedISO: "2019-09-10T00:00:00+00:00")
        let currency = CurrencyResponseModel(code: "EUR", rateFloat: rate)
        let bpi = BpiResponseModel(usd: nil, gbp: nil, eur: currency)
        let todayResponse = TodayResponseModel(time: time, bpi: bpi)
        return todayResponse
    }
}
