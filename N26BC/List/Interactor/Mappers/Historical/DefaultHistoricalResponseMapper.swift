//
//  DefaultHistoricalResponseMapper.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultHistoricalResponseMapper: HistoricalResponseMapperProtocol {
    func map(response: HistoricalResponseModel, for currency: Currency, completion: @escaping (Result<[Valuation], ShowableError>) -> Void) {
        guard let bpi = response.bpi else {
            completion(.failure(ShowableError.other))
            return
        }
        let prices: [Valuation] = bpi.compactMap {
            guard let date = $0.key.toDateWithFormat(BitcoinDeskAPI.defaultDateFormat) else {
                return nil
            }
            return Valuation(date: date, price: $0.value, currency: currency)
        }
        completion(.success(prices))
    }
}
