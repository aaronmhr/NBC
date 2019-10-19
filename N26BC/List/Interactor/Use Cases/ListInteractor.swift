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
    var historicalProvider: HistoricalProviderProtocol { get }
    var todayProvider: TodayProviderProtocol { get }
    var valuationSorter: ValuationSorterProtocol { get }
    var timer: TimerProtocol { get }
}

final class DefaultListInteractorDependencies: ListInteractorDependenciesProtocol {
    
    let urlSession = URLSession(configuration: .default)
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    lazy var valuationSorter: ValuationSorterProtocol = ValuationSorter()
    lazy var historicalResponseMapper: HistoricalResponseMapperProtocol = DefaultHistoricalResponseMapper()
    lazy var historicalDataRepository: HistoricalDataRepository = DefaultHistoricalDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder), mapper: historicalResponseMapper)

    lazy var todayResponseMapper: CurrentResponseMapperProtocol = DefaultCurrentResponseMapper()
    lazy var currentDataRepository: TodayDataRepository = DefaultTodayDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder), mapper: todayResponseMapper)
    
    lazy var historicalProvider: HistoricalProviderProtocol = HistoricalDataProvider(repository: historicalDataRepository)
    lazy var todayProvider: TodayProviderProtocol = TodayDataProvider(repository: currentDataRepository)
    lazy var timer: TimerProtocol = DefaultTimer()
}

final class ListInteractor {
    let dependencies: ListInteractorDependenciesProtocol
    
    init(dependencies: ListInteractorDependenciesProtocol = DefaultListInteractorDependencies()) {
        self.dependencies = dependencies
    }
}

extension ListInteractor: ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[Valuation], N26BCError>) -> Void) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: Constants.daysInPeriod, to: end) ?? end
        dependencies.historicalProvider.retrieveHistoricalData(start: start, end: end, currency: Constants.currency) { [weak self] result in
            guard let self = self else  { return }
            completion(self.dependencies.valuationSorter.sort(result))
        }
    }
    
    func retrieveCurrentData(completion: @escaping (Result<Valuation, N26BCError>) -> Void) {
        dependencies.todayProvider.retrieveTodayData(completion: completion)
    }
}

extension ListInteractor  {
    private enum Constants {
        static let currency: Currency = Currency.euro
        static let daysInPeriod = -14
    }
}
