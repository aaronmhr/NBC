//
//  DefaultTodayResponseMapper.swift
//  NBC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Networking

public final class DefaultTodayResponseMapper: TodayResponseMapperProtocol {
    public init() { }
    public func map(response: TodayResponseModel, for currency: Currency) -> Result<Valuation, BCError> {
        guard let dateString = response.time?.updatedISO,
            let date = dateString.toDateWithFormat(BitcoinDeskAPI.todayFormatter) else {
            return .failure(.other)
        }
        let rate: Result<Double, BCError>
        switch currency {
        case .euro:
            rate = unwrap(rate: response.bpi?.eur?.rateFloat)
        case .dollar:
            rate = unwrap(rate: response.bpi?.usd?.rateFloat)
        case .pound:
            rate = unwrap(rate: response.bpi?.gbp?.rateFloat)
        default:
            return .failure(.other)
        }
        let valuation: Result<Valuation, BCError> = rate.map { Valuation(date: date, price: $0, currency: currency) }
        return valuation
    }
    
    private func unwrap(rate: Double?) -> Result<Double, BCError> {
        guard let rate = rate else {
            return .failure(.other)
        }
        return .success(rate)
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
