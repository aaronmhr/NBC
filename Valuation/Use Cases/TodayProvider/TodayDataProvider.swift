//
//  TodayProvider.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

public final class TodayDataProvider: TodayProviderProtocol {
    private let repository: TodayDataRepository
    
    public init(repository: TodayDataRepository) {
        self.repository = repository
    }
    
    public func retrieveTodayData(currency: Currency, completion: @escaping ResultBlock) {
        let url = getBitcoinDeskAPIURL(currency: currency)
        repository.getTodayData(url: url, currency: currency, completion: completion)
    }
    
    private func getBitcoinDeskAPIURL(currency: Currency) -> URL? {
        let url = BitcoinDeskAPI.today(currency).url
        return url
    }
}
