//
//  TodayTableViewModel.swift
//  NBC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons
import Valuation

struct TodayTableViewModel: ListViewSection {
    let title: String
    let rows: [PricesViewModel]
    let sectionType: ListSectionType = .today
    
    init(title: String, rows: [PricesViewModel]) {
        self.title = title
        self.rows = rows
    }
    
    static func makeSectionViewModel(from model: [Valuation], title: String, type: ListSectionType) -> TodayTableViewModel {
        
        let pricesModel: [PricesViewModel] = model.map {
            let date: String = $0.date.toStringWithFormat("MM-dd-yyyy HH:mm:ss")
            let price = "1BTC = \($0.price) \($0.currency.rawValue)"
            return PricesViewModel(date: date, price: price)
        }
        
        return TodayTableViewModel(title: title, rows: pricesModel)
    }
}