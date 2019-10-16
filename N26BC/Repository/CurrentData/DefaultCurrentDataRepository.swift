//
//  DefaultCurrentDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultCurrentDataRepository: CurrentDataRepository {
    private let dependencies: NetworkingDependenciesProtocol
    
    init(dependencies: NetworkingDependenciesProtocol = DefaultNetworkingDependencies()) {
        self.dependencies = dependencies
    }
    
    func getCurrentData(url: URL?, completion: @escaping (Result<CurrentResponseModel, ShowableError>) -> Void) {
        self.dependencies.apiService.fetchResources(url: url) { (result: Result<CurrentResponseModel, NetworkingError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(ShowableError.networking))
            }
        }
    }
}
