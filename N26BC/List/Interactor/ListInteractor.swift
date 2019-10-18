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
    var timer: TimerProtocol { get }
    var historicalResponseMapper: HistoricalResponseMapperProtocol { get }
    var todayResponseMapper: CurrentResponseMapperProtocol { get }
}

final class DefaultListInteractorDependencies: ListInteractorDependenciesProtocol {
    let urlSession = URLSession(configuration: .default)
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    lazy var historicalDataRepository: HistoricalDataRepository = DefaultHistoricalDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder))
    lazy var currentDataRepository: CurrentDataRepository = DefaultCurrentDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder))
    lazy var timer: TimerProtocol = DefaultTimer()
    lazy var historicalResponseMapper: HistoricalResponseMapperProtocol = DefaultHistoricalResponseMapper()
    lazy var todayResponseMapper: CurrentResponseMapperProtocol = DefaultCurrentResponseMapper()
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
        let start = Calendar.current.date(byAdding: .day, value: -14, to: end) ?? end
        let url = BitcoinDeskAPI.historical(.init(start: start, end: end, currency: .euro)).url
        dependencies.historicalDataRepository.getHistoricalData(url: url) { [weak self] result in
            self?.mapHistoricalResponse(response: result, completion: completion)
        }
    }
    
    private func mapHistoricalResponse(response: Result<HistoricalResponseModel, ShowableError>, completion: @escaping (Result<[Valuation], ShowableError>) -> Void) {
        switch response {
        case .success(let repositoryResponse):
            dependencies.historicalResponseMapper.map(response: repositoryResponse, for: .euro) { [weak self] mappedResponse in
                self?.handleMappedResponse(response: mappedResponse, completion: completion)
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func handleMappedResponse(response: Result<[Valuation], ShowableError>, completion: @escaping (Result<[Valuation], ShowableError>) -> Void) {
        switch response {
        case .success(let prices):
            let sortedPrices = sort(prices)
            completion(.success(sortedPrices))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func sort(_ items: [Valuation]) -> [Valuation] {
        return items.sorted { $0.date > $1.date }
    }
    
    func retrieveCurrentData(completion: @escaping (Result<Valuation, ShowableError>) -> Void) {
        let url = BitcoinDeskAPI.today(.euro).url
        dependencies.currentDataRepository.getCurrentData(url: url) { [weak self] result in
            switch result {
            case .success(let reponse):
                self?.dependencies.todayResponseMapper.map(response: reponse, for: .euro, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
