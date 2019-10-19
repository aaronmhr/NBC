//
//  TodayProvider.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class TodayDataProvider: TodayProviderProtocol {
    let repository: TodayDataRepository
    
    init(repository: TodayDataRepository) {
        self.repository = repository
    }
    
    func retrieveTodayData(completion: @escaping ResultBlock) {
        let url = BitcoinDeskAPI.today(.euro).url
        repository.getTodayData(url: url, completion: completion)
    }
}
