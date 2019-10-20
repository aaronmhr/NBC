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
    private let mapper: HistoricalResponseMapperProtocol
    
    init(networking: URLSessionClientProtocol, mapper: HistoricalResponseMapperProtocol) {
        self.networking = networking
        self.mapper = mapper
    }
    
    func getHistoricalData(url: URL?, completion: @escaping HistoricalProviderProtocol.ResultBlock) {
        self.networking.fetchResources(url: url) { [weak self] (result: Result<HistoricalResponseModel, NetworkingError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(self.mapper.map(response: response, for: .euro))
            case .failure(let error):
                completion(.failure(self.mapper.map(error: error)))
            }
        }
    }
}