//
//  ValuationSorterProtocol.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

protocol ValuationSorterProtocol {
    func sort(_ items: Result<[Valuation], N26BCError>) -> Result<[Valuation], N26BCError>
}
