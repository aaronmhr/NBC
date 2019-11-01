//
//  DefaultHistoricalResponseMapper.swift
//  NBC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Networking

public final class DefaultHistoricalResponseMapper: HistoricalResponseMapperProtocol {
    public init() { }
    public func map(response: HistoricalResponseModel, for currency: Currency) -> Result<[Valuation], BCError> {
        guard let bpi = response.bpi else {
            return .failure(BCError.other)
        }
        let prices: [Valuation] = bpi.compactMap {
            guard let date = $0.key.toDateWithFormat(BitcoinDeskAPI.historicalFormatter) else {
                return nil
            }
            return Valuation(date: date, price: $0.value, currency: currency)
        }
        return .success(prices)
    }
    
    public func map(error: NetworkingError) -> BCError {
        let newError: BCError
        switch error {
        default:
            newError = .networking
        }
        return newError
    }
}
