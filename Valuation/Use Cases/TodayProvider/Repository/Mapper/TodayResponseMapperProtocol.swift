//
//  TodayResponseMapperProtocol.swift
//  NBC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

public protocol TodayResponseMapperProtocol {
    func map(response: TodayResponseModel, for currency: Currency) -> Result<Valuation, BCError>
    func map(error: NetworkingError) -> BCError
}
