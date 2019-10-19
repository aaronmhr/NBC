//
//  HistoricalDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

protocol HistoricalDataRepository {
    func getHistoricalData(url: URL?, completion: @escaping HistoricalProviderProtocol.ResultBlock)
}
