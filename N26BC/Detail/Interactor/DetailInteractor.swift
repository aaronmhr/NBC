//
//  DetailInteractor.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Networking

final class DetailInteractor {
    let historicalProvider: HistoricalProviderProtocol
    let todayProvider: TodayProviderProtocol
    
    init(historicalProvider: HistoricalProviderProtocol, todayProvider: TodayProviderProtocol) {
        self.historicalProvider = historicalProvider
        self.todayProvider = todayProvider
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    
}
