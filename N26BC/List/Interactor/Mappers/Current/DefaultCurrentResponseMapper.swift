//
//  DefaultCurrentResponseMapper.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultCurrentResponseMapper: CurrentResponseMapperProtocol {
    func map(response: CurrentResponseModel, for currency: Currency, completion: @escaping (Result<Valuation, ShowableError>) -> Void) {
        let date = response.time?.updatedISO.toDateWithFormat(BitcoinDeskAPI.todayResponseDateFormat) ?? Date()
        guard let price = response.bpi?.eur?.rateFloat else {
            completion(.failure(.other))
            return
        }
        let valuation = Valuation(date: date, price: price, currency: currency)
        completion(.success(valuation))
    }
}
