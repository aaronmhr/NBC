//
//  HistoricalProviderProtocol.swift
//  NBC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Networking

public protocol HistoricalProviderProtocol {
    typealias HistoricalResult = Result<[Valuation], BCError>
    typealias ResultBlock = (Result<[Valuation], BCError>) -> Void
    
    func retrieveHistoricalData(start: Date, end: Date, currency: Currency, completion: @escaping ResultBlock)
}
