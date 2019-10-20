//
//  TodayResponseModel.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

private typealias Decodable = Swift.Decodable & Equatable

public struct TodayResponseModel: Decodable {
    let time: TimeResponseModel?
    let bpi: BpiResponseModel?
}

// MARK: BpiResponseModel
public struct BpiResponseModel: Decodable {
    let usd, gbp, eur: CurrencyResponseModel?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

// MARK: CurrencyResponseModel
public struct CurrencyResponseModel: Decodable {
    let code: String?
    let rateFloat: Double?
}

// MARK: TimeResponseModel
public struct TimeResponseModel: Decodable {
    let updatedISO: String?
}
