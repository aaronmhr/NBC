//
//  DefaultHistoricalResponseMapper.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultHistoricalResponseMapper: HistoricalResponseMapperProtocol {
    func map(response: HistoricalResponseModel, for currency: Currency) -> Result<[Valuation], ShowableError> {
        guard let bpi = response.bpi else {
            return .failure(ShowableError.other)
        }
        let prices: [Valuation] = bpi.compactMap {
            guard let date = $0.key.toDateWithFormat(BitcoinDeskAPI.defaultDateFormat) else {
                return nil
            }
            return Valuation(date: date, price: $0.value, currency: currency)
        }
        return .success(prices)
    }
    
    func map(error: NetworkingError) -> ShowableError {
        let newError: ShowableError
        switch error {
        default:
            newError = .networking
        }
        return newError
    }
}
