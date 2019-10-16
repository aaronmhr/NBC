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
    var currentDataRepository: CurrentDataRepository { get }
}

final class DefaultListInteractorDependencies: ListInteractorDependenciesProtocol {
    lazy var historicalDataRepository: HistoricalDataRepository = DefaultHistoricalDataRepository()
    lazy var currentDataRepository: CurrentDataRepository = DefaultCurrentDataRepository()
}

final class ListInteractor {
    let dependencies: ListInteractorDependenciesProtocol
    
    init(dependencies: ListInteractorDependenciesProtocol = DefaultListInteractorDependencies()) {
        self.dependencies = dependencies
    }
}

extension ListInteractor: ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[Valuation], ShowableError>) -> Void) {
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
                let prices: [Valuation] = bpi.map {
                    let date = $0.key.toDateWithFormat(BitcoinDeskAPI.defaultDateFormat)!
                    return Valuation(date: date, price: $0.value, currency: .euro)
                }
                let sortedPrices = prices.sorted { $0.date > $1.date }
                completion(.success(sortedPrices))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveCurrentData(completion: @escaping (Result<Valuation, ShowableError>) -> Void) {
        let url = BitcoinDeskAPI.today(.euro).url
        dependencies.currentDataRepository.getCurrentData(url: url) { result in
            switch result {
            case .success(let reponse):
                let date = reponse.time?.updatedISO.toDateWithFormat("yyyy-MM-dd'T'HH:mm:ss+00:00") ?? Date()
                guard let price = reponse.bpi?.eur?.rateFloat else {
                    completion(.failure(.other))
                    return
                }
                let valuation = Valuation(date: date, price: price, currency: .euro)
                completion(.success(valuation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
