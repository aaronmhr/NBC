//
//  HistoricalPrice.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

struct HistoricalPrice {
    let date: Date
    let price: Double
    let currency: Currency
}

enum Currency: String {
    case euro = "EUR"
    case dollar = "USD"
    case pound = "GBP"
}
