//
//  HistoricalProvider.swift
//  NBC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Networking

public final class HistoricalDataProvider: HistoricalProviderProtocol {
    let repository: HistoricalDataRepository
    
    public init(repository: HistoricalDataRepository) {
        self.repository = repository
    }
    
    public func retrieveHistoricalData(start: Date, end: Date, currency: Currency, completion: @escaping ResultBlock) {
        let url = getBitcoinDeskAPIURL(start: start, end: end, currency: currency)
        repository.getHistoricalData(url: url, currency: currency, completion: completion)
    }
    
    private func getBitcoinDeskAPIURL(start: Date, end: Date, currency: Currency) -> URL? {
        let url = BitcoinDeskAPI.historical(.init(start: start, end: end, currency: currency)).url
        return url
    }
}
