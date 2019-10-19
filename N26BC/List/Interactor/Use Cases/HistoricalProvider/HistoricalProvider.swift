//
//  HistoricalProvider.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class HistoricalDataProvider: HistoricalProviderProtocol {
    let repository: HistoricalDataRepository
    
    init(repository: HistoricalDataRepository) {
        self.repository = repository
    }
    
    func retrieveHistoricalData(completion: @escaping ResultBlock) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -14, to: end) ?? end
        let url = BitcoinDeskAPI.historical(.init(start: start, end: end, currency: .euro)).url
        
        repository.getHistoricalData(url: url, completion: completion)
    }
}
