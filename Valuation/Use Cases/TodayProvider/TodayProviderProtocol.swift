//
//  TodayProviderProtocol.swift
//  NBC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

public protocol TodayProviderProtocol {
    typealias TodayResult = Result<Valuation, BCError>
    typealias ResultBlock = (Result<Valuation, BCError>) -> Void
    
    func retrieveTodayData(currency: Currency, completion: @escaping ResultBlock)
}
