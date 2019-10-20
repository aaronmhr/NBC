//
//  DefaultHistoricalResponseMapper.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultHistoricalResponseMapper: HistoricalResponseMapperProtocol {
    func map(response: HistoricalResponseModel, for currency: Currency) -> Result<[Valuation], N26BCError> {
        guard let bpi = response.bpi else {
            return .failure(N26BCError.other)
        }
        let prices: [Valuation] = bpi.compactMap {
            guard let date = $0.key.toDateWithFormat(BitcoinDeskAPI.historicalFormatter) else {
                return nil
            }
            return Valuation(date: date, price: $0.value, currency: currency)
        }
        return .success(prices)
    }
    
    func map(error: NetworkingError) -> N26BCError {
        let newError: N26BCError
        switch error {
        default:
            newError = .networking
        }
        return newError
    }
}
