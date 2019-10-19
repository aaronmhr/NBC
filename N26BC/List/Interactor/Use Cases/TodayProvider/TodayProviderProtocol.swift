//
//  TodayProviderProtocol.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

protocol TodayProviderProtocol {
    typealias TodayResult = Result<Valuation, N26BCError>
    typealias ResultBlock = (Result<Valuation, N26BCError>) -> Void
    
    func retrieveTodayData(completion: @escaping ResultBlock)
}
