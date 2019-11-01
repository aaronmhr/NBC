//
//  HistoricalResponseMapperProtocol.swift
//  N26BC
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

public protocol HistoricalResponseMapperProtocol {
    func map(response: HistoricalResponseModel, for currency: Currency) -> Result<[Valuation], BCError>
    func map(error: NetworkingError) -> BCError
}
