//
//  TodayProtocols.swift
//  N26BC
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Valuation

protocol TodayInteractorProtocol {
    func retrieveTodayData(completion: @escaping (Result<Valuation, N26BCError>) -> Void)
    func stopRetreavingTodayData()
}

protocol TodayRouterProtocol {
}

protocol TodayPresenterProtocol {
    func viewWillAppear()
}

protocol TodayViewProtocol: class {
    var viewModel: String? { get set }
}
