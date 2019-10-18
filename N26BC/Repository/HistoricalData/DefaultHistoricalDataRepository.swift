//
//  DefaultHistoricalDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultHistoricalDataRepository: HistoricalDataRepository {
    private let networking: URLSessionClientProtocol
    
    init(networking: URLSessionClientProtocol) {
        self.networking = networking
    }
    
    func getHistoricalData(url: URL?, completion: @escaping (Result<HistoricalResponseModel, ShowableError>) -> Void) {
        self.networking.fetchResources(url: url) { (result: Result<HistoricalResponseModel, NetworkingError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(ShowableError.networking))
            }
        }
    }
}
