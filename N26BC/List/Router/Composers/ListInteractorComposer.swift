//
//  ListInteractorComposer.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Networking
import Valuation

final class ListInteractorComposer {
    static func compose() -> ListInteractor {
        let urlSession = URLSession(configuration: .default)
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let historicalResponseMapper: HistoricalResponseMapperProtocol = DefaultHistoricalResponseMapper()
        let historicalDataRepository: HistoricalDataRepository = DefaultHistoricalDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder), mapper: historicalResponseMapper)
        let todayResponseMapper: TodayResponseMapperProtocol = DefaultTodayResponseMapper()
        let todayDataRepository: TodayDataRepository = DefaultTodayDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder), mapper: todayResponseMapper)
        
        let historicalProvider: HistoricalProviderProtocol = HistoricalDataProvider(repository: historicalDataRepository)
        let todayProvider: TodayProviderProtocol = TodayDataProvider(repository: todayDataRepository)
        let valuationSorter: ValuationSorterProtocol = ValuationSorter()
        let timer: TimerProtocol = DefaultTimer()
        
        return ListInteractor(historicalProvider: historicalProvider, todayProvider: todayProvider, valuationSorter: valuationSorter, timer: timer)
    }
}
