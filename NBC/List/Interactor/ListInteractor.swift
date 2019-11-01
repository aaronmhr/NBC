//
//  ListInteractor.swift
//  NBC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Networking
import Valuation

final class ListInteractor {
    let historicalProvider: HistoricalProviderProtocol
    let todayProvider: TodayProviderProtocol
    let valuationSorter: ValuationSorterProtocol
    let timer: TimerProtocol
    
    init(historicalProvider: HistoricalProviderProtocol, todayProvider: TodayProviderProtocol, valuationSorter: ValuationSorterProtocol, timer: TimerProtocol) {
        self.historicalProvider = historicalProvider
        self.todayProvider = todayProvider
        self.valuationSorter = valuationSorter
        self.timer = timer
    }
}

extension ListInteractor: ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[Valuation], BCError>) -> Void) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: Constants.daysInPeriod, to: end) ?? end
        historicalProvider.retrieveHistoricalData(start: start, end: end, currency: Constants.currency) { [weak self] result in
            guard let self = self else  { return }
            completion(self.valuationSorter.sort(result))
        }
    }
    
    func retrieveTodayData(completion: @escaping (Result<Valuation, BCError>) -> Void) {
        timer.schedule(timeInterval: Constants.todayCallPeriod, repeats: true) { [weak self] in
            self?.todayProvider.retrieveTodayData(currency: Constants.currency, completion: completion)
        }
        timer.fire()
    }
    
    func stopRetreavingTodayData() {
        timer.invalidate()
    }
}

extension ListInteractor  {
    private enum Constants {
        static let currency: Currency = Currency.euro
        static let daysInPeriod = -14
        static let todayCallPeriod: TimeInterval = 60
    }
}
