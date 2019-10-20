//
//  DetailInteractorComposer.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Valuation
import Networking

final class DetailInteractorComposer {
    static func compose() -> DetailInteractor {
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
        return DetailInteractor(historicalProvider: historicalProvider, todayProvider: todayProvider)
    }
}
