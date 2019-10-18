//
//  TestingURLSessionClient.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 18/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Networking

final class TestingURLSessionClient<T: Decodable>: URLSessionClientProtocol {
    var result: Result<T, NetworkingError>?
    
    func fetchResources<T: Decodable>(url: URL?, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let result = self.result as? Result<T, NetworkingError> else {
            XCTFail()
            return
        }
        completion(result)
    }
}
