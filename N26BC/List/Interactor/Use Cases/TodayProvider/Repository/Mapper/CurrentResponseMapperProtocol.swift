//
//  CurrentResponseMapperProtocol.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

protocol CurrentResponseMapperProtocol {
    func map(response: TodayResponseModel, for currency: Currency, completion: @escaping (Result<Valuation, N26BCError>) -> Void)
}
