//
//  ListInteractor.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Networking

protocol ListInteractorDependenciesProtocol {
    var historicalDataRepository: HistoricalDataRepository { get }
}

final class DefaultListInteractorDependencies: ListInteractorDependenciesProtocol {
    lazy var historicalDataRepository: HistoricalDataRepository = DefaultHistoricalDataRepository()
}

final class ListInteractor {
    let dependencies: ListInteractorDependenciesProtocol
    
    init(dependencies: ListInteractorDependenciesProtocol = DefaultListInteractorDependencies()) {
        self.dependencies = dependencies
    }
}

extension ListInteractor: ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[HistoricalPrice], ShowableError>) -> Void) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -14, to: end)!
        let url = BitcoinDeskAPI.historical(.init(start: start, end: end, currency: .euro)).url
        dependencies.historicalDataRepository.getHistoricalData(url: url) { result in
            switch result {
            case .success(let response):
                guard let bpi = response.bpi else {
                    completion(.failure(ShowableError.other))
                    return
                }
                let prices: [HistoricalPrice] = bpi.map {
                    let date = $0.key.toDateWithFormat(BitcoinDeskAPI.defaultDateFormat)!
                    return HistoricalPrice(date: date, price: $0.value, currency: .euro)
                }
                let sortedPrices = prices.sorted { $0.date > $1.date }
                completion(.success(sortedPrices))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
