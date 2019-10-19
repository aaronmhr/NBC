//
//  DefaultTodayResponseMapper.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultTodayResponseMapper: TodayResponseMapperProtocol {
    func map(response: TodayResponseModel, for currency: Currency) -> Result<Valuation, N26BCError> {
        let date = response.time?.updatedISO.toDateWithFormat(BitcoinDeskAPI.todayResponseDateFormat) ?? Date()
        guard let price = response.bpi?.eur?.rateFloat else {
            return .failure(.other)
        }
        let valuation = Valuation(date: date, price: price, currency: currency)
        return .success(valuation)
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
