//
//  TodayDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public protocol TodayDataRepository {
    func getTodayData(url: URL?, currency: Currency, completion: @escaping TodayProviderProtocol.ResultBlock)
}
