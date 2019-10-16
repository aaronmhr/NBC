//
//  CurrentResponseModel.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

struct CurrentResponseModel: Decodable {
    let time: TimeResponseModel?
    let bpi: BpiResponseModel?
}

// MARK: BpiResponseModel
struct BpiResponseModel: Decodable {
    let usd, gbp, eur: CurrencyResponseModel?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

// MARK: CurrencyResponseModel
struct CurrencyResponseModel: Decodable {
    let code: String?
    let rateFloat: Double?
}

// MARK: TimeResponseModel
struct TimeResponseModel: Decodable {
    let updatedISO: String?
}
