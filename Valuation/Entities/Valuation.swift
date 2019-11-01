//
//  Valuation.swift
//  NBC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public struct Valuation: Equatable {
    public let date: Date
    public let price: Double
    public let currency: Currency
    
    public init(date: Date, price: Double, currency: Currency) {
        self.date = date
        self.price = price
        self.currency = currency
    }
}
