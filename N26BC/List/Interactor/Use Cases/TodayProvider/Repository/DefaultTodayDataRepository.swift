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
    private let mapper: TodayResponseMapperProtocol
    
    init(networking: URLSessionClientProtocol, mapper: TodayResponseMapperProtocol) {
        self.networking = networking
        self.mapper = mapper
    }
    
    func getTodayData(url: URL?, completion: @escaping TodayProviderProtocol.ResultBlock) {
        self.networking.fetchResources(url: url) { [weak self] (result: Result<TodayResponseModel, NetworkingError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(self.mapper.map(response:response, for: .euro))
            case .failure(let error):
                completion(.failure(self.mapper.map(error: error)))
            }
        }
    }
}
