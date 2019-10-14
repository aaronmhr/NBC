//
//  URLSessioClientTests.swift
//  NetworkingTests
//
//  Created by Aaron Huánuco on 14/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Networking

class URLSessionClientTests: XCTestCase {
    func testInit_URLSessionAssignedVariableIsNotNil() {
        let (sut, _) = makeSUT()
        XCTAssertNotNil(sut)
    }
    
    func testFetchResources_whenGivenNilURL_returnsNetworkingErrorCouldNotBuildURL() {
        let networkingError = NetworkingError.couldNotBuildURL
        let (sut, _) = makeSUT()
        
        sut.fetchResources(url: nil) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenValidURLButGotNonHTTPURLResponse_returnsNetworkingErrorInvalidResponse() {
        let networkingError = NetworkingError.invalidResponse
        let (sut, session) = makeSUT()
        let (url, nonHTTPResponse) = givenValidURLWithNonHTTPResponse()
        session.whenDealingWith(.success(nonHTTPResponse))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenThereIsClientError_returnsNetworkingErrorClientError() {
        let (sut, session) = makeSUT()
        let (url, httpResponse, networkingError) = givenClientErrorHTTPResponse()
        session.whenDealingWith(.success(httpResponse))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenThereIsServerError_returnsNetworkingErrorServerError() {
        let (sut, session) = makeSUT()
        let (url, httpResponse, networkingError) = givenServerErrorHTTPResponse()
        session.whenDealingWith(.success(httpResponse))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenThereIsOtherError_returnsNetworkingErrorOtherError() {
        let (sut, session) = makeSUT()
        let (url, httpResponse, networkingError) = givenOtherErrorHTTPResponse()
        session.whenDealingWith(.success(httpResponse))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenRequestSuccedsButWrongObject_returnsNetworkingErrorDecodingError() {
        let (sut, session) = makeSUTRegularDecoding()
        let networkingError = NetworkingError.couldNotBuildURL
        let (url, httpResponse) = givenDecodingError()
        session.whenDealingWith(.success(httpResponse))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    func testFetchResources_whenThereSuccedes_returnsDecodedObject() {
        let (sut, session) = makeSUT()
        let property = "A"
        let anotherProperty = "B"
        let (url, httpResponse) = givenSuccessfulRequets(property: property, anotherProperty: anotherProperty)
        let object = MockModelResponse(property: property, anotherProperty: anotherProperty)
        session.whenDealingWith(.success(httpResponse))

        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertSuccess(result: result, object: object)
        }
    }
    
    func testFetchResources_canHandleOrdinaryError() {
        let url = URL(string: "https://apple.com")!
        let error = NSError(domain: "Unidentified Error at \(#file)", code: 0, userInfo: nil)
        let networkingError = NetworkingError.other("\(error.code)")
        let (sut, session) = makeSUT()
        session.whenDealingWith(.failure(error))
        
        sut.fetchResources(url: url) { [weak self] (result: Result<MockModelResponse, NetworkingError>) in
            self?.assertFailure(result: result, error: networkingError)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (URLSessionClient, URLSessionSpy) {
        let session = URLSessionSpy()
        let decoder = getSnakeCaseAdapterJSONDecoder()
        return (URLSessionClient(session: session, decoder: decoder), session)
    }
    
    private func makeSUTRegularDecoding() -> (URLSessionClient, URLSessionSpy) {
        let session = URLSessionSpy()
        let decoder = getRegularJSONDecoder()
        return (URLSessionClient(session: session, decoder: decoder), session)
    }
    
    private func getRegularJSONDecoder() -> JSONDecoder {
        return JSONDecoder()
    }
    
    private func getSnakeCaseAdapterJSONDecoder() -> JSONDecoder {
        let decoder = getRegularJSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private func assertFailure(result: Result<MockModelResponse, NetworkingError>, error: NetworkingError, file: StaticString = #file, line: UInt = #line) {
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, error)
            XCTAssertEqual(error.description, error.description)
        case .success:
            XCTFail("Unidentified", file: file, line: line)
        }
    }
    
    private func assertSuccess(result: Result<MockModelResponse, NetworkingError>, object: MockModelResponse, file: StaticString = #file, line: UInt = #line) {
        switch result {
        case .failure:
            XCTFail("Unidentified", file: file, line: line)
        case .success(let response):
            XCTAssertEqual(response, object)
        }
    }
    
    private func makeSimpleJSON(_ dictionary: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: dictionary)
    }
    
    private func givenValidURLWithNonHTTPResponse() -> (url: URL, response: (URLResponse, Data)) {
        let url = URL(string: "https://apple.com")!
        let urlResponse = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let data = Data("something".utf8)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        return (url, tuple)
    }
    
    private func givenClientErrorHTTPResponse() -> (url: URL, response: (URLResponse, Data), error: NetworkingError) {
        let url = URL(string: "https://apple.com")!
        let statusCode = 404
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let data = Data("something".utf8)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        let networkingError = NetworkingError.clientError("\(statusCode)")
        return (url, tuple, networkingError)
    }
    
    private func givenServerErrorHTTPResponse() -> (url: URL, response: (URLResponse, Data), error: NetworkingError) {
        let url = URL(string: "https://apple.com")!
        let statusCode = 500
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let data = Data("something".utf8)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        let networkingError = NetworkingError.clientError("\(statusCode)")
        return (url, tuple, networkingError)
    }
    
    private func givenOtherErrorHTTPResponse() -> (url: URL, response: (URLResponse, Data), error: NetworkingError) {
        let url = URL(string: "https://apple.com")!
        let statusCode = 0
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let data = Data("something".utf8)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        let networkingError = NetworkingError.clientError("\(statusCode)")
        return (url, tuple, networkingError)
    }
    
    private func givenDecodingError() -> (url: URL, response: (URLResponse, Data)) {
        let url = URL(string: "https://apple.com")!
        let statusCode = 200
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let dict: [String: Any] = ["property" : "A", "another_property" : "B"]
        let data = makeSimpleJSON(dict)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        return (url, tuple)
    }
    
    private func givenSuccessfulRequets(property: String, anotherProperty: String) -> (url: URL, response: (URLResponse, Data)) {
        let url = URL(string: "https://apple.com")!
        let statusCode = 200
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let dict: [String: Any] = ["property" : "\(property)", "another_property" : "\(anotherProperty)" ]
        let data = makeSimpleJSON(dict)
        let tuple: (URLResponse, Data) = (urlResponse, data)
        return (url, tuple)
    }

    
    // MARK: - Auxiliary Objects
    private class URLSessionSpy: URLSessionProtocol {
        private var result: RemoteResult = .failure(NSError(domain: "", code: 0, userInfo: nil))
        
        func whenDealingWith(_ result: RemoteResult) {
            self.result = result
        }
        
        func makeRequest(for url: URL, completion: @escaping (RemoteResult) -> Void) -> URLSessionDataTask? {
            completion(result)
            return nil
        }
    }
    
    struct MockModelResponse: Decodable, Equatable {
        let property: String
        let anotherProperty: String
    }
}
