//
//  DefaultCurrentDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultCurrentDataRepository: CurrentDataRepository {
    private let networking: URLSessionClientProtocol
    
    init(networking: URLSessionClientProtocol) {
        self.networking = networking
    }
    
    func getCurrentData(url: URL?, completion: @escaping (Result<CurrentResponseModel, ShowableError>) -> Void) {
        self.networking.fetchResources(url: url) { (result: Result<CurrentResponseModel, NetworkingError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(ShowableError.networking))
            }
        }
    }
}
