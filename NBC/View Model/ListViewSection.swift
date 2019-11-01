//
//  ListViewSection.swift
//  NBC
//
//  Created by Aaron Huánuco on 17/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

protocol ListViewSection {
    var title: String { get }
    var rows: [PricesViewModel] { get }
}
