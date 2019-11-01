//
//  TodayInteractorComposer.swift
//  BitCoinPrice
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Networking
import Valuation

final class TodayInteractorComposer {
    static func compose() -> TodayInteractor {
        let urlSession = URLSession(configuration: .default)
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        

        let todayResponseMapper: TodayResponseMapperProtocol = DefaultTodayResponseMapper()
        let todayDataRepository: TodayDataRepository = DefaultTodayDataRepository(networking: URLSessionClient(session: urlSession, decoder: decoder), mapper: todayResponseMapper)
        let todayProvider: TodayProviderProtocol = TodayDataProvider(repository: todayDataRepository)

        let timer: TimerProtocol = DefaultTimer()
        
        return TodayInteractor(todayProvider: todayProvider, timer: timer)
    }
}
