//
//  ValuationSorter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 19/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public final class ValuationSorter: ValuationSorterProtocol {
    public init() { }
    public func sort(_ result: Result<[Valuation], BCError>) -> Result<[Valuation], BCError> {
        return result.map { $0.sorted { $0.date > $1.date }}
    }
}
