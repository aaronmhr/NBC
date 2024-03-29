//
//  DefaultTodayDataRepository.swift
//  NBC
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Networking

public final class DefaultTodayDataRepository: TodayDataRepository {
    private let networking: URLSessionClientProtocol
    private let mapper: TodayResponseMapperProtocol
    
    public init(networking: URLSessionClientProtocol, mapper: TodayResponseMapperProtocol) {
        self.networking = networking
        self.mapper = mapper
    }
    
    public func getTodayData(url: URL?, currency: Currency, completion: @escaping TodayProviderProtocol.ResultBlock) {
        self.networking.fetchResources(url: url) { [weak self] (result: Result<TodayResponseModel, NetworkingError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(self.mapper.map(response:response, for: currency))
            case .failure(let error):
                completion(.failure(self.mapper.map(error: error)))
            }
        }
    }
}
