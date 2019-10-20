//
//  TodayResponseMapperProtocol.swift
//  N26BC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

protocol TodayResponseMapperProtocol {
    func map(response: TodayResponseModel, for currency: Currency) -> Result<Valuation, N26BCError>
    func map(error: NetworkingError) -> N26BCError
}
