//
//  DefaultTodayDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultTodayDataRepository: TodayDataRepository {
    private let networking: URLSessionClientProtocol
    
    init(networking: URLSessionClientProtocol) {
        self.networking = networking
    }
    
    func getTodayData(url: URL?, completion: @escaping (Result<TodayResponseModel, ShowableError>) -> Void) {
        self.networking.fetchResources(url: url) { (result: Result<TodayResponseModel, NetworkingError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(ShowableError.networking))
            }
        }
    }
}
