//
//  HistoricalResponseModel.swift
//  NBC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public struct HistoricalResponseModel: Decodable, Equatable {
    let bpi: [String: Double]?
    let disclaimer: String?
}
