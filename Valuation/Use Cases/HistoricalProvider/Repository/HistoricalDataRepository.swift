//
//  HistoricalDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public protocol HistoricalDataRepository {
    func getHistoricalData(url: URL?, currency: Currency, completion: @escaping HistoricalProviderProtocol.ResultBlock)
}
