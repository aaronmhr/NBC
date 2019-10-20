//
//  DetailInteractor.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Networking
import Valuation

final class DetailInteractor {
    let historicalProvider: HistoricalProviderProtocol
    let todayProvider: TodayProviderProtocol
    let valuation: Valuation
    
    init(historicalProvider: HistoricalProviderProtocol, todayProvider: TodayProviderProtocol, valuation: Valuation) {
        self.historicalProvider = historicalProvider
        self.todayProvider = todayProvider
        self.valuation = valuation
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func retrieveData(for currency: Currency, date: Date, completion: @escaping (Result<Valuation, N26BCError>) -> Void) {
        let isToday = Calendar.current.isDateInToday(date)
        switch isToday {
        case true:
            retrieveToday(for: currency, date: date, completion: completion)
        case false:
            retrieveHistorical(for: currency, date: date, completion: completion)
        }
    }
    
    private func retrieveToday(for currency: Currency, date: Date, completion: @escaping (Result<Valuation, N26BCError>) -> Void) {
        todayProvider.retrieveTodayData(currency: currency) { result in
            completion(result)
        }
    }
    
    private func retrieveHistorical(for currency: Currency, date: Date, completion: @escaping (Result<Valuation, N26BCError>) -> Void) {
        historicalProvider.retrieveHistoricalData(start: date, end: date, currency: currency) { resultArray in
            let result: Result<Valuation, N26BCError> = resultArray.flatMap {
                guard let valuation = $0.first else {
                    return .failure(N26BCError.other)
                }
                return .success(valuation)
            }
            completion(result)
        }
    }
}
