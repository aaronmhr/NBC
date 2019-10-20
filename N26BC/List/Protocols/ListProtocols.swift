//
//  ListProtocols.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Valuation

protocol ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[Valuation], N26BCError>) -> Void)
    func retrieveTodayData(completion: @escaping (Result<Valuation, N26BCError>) -> Void)
    func stopRetreavingTodayData()
}

protocol ListRouterProtocol {
    func showDetailView(for valuation: Valuation?)
}

protocol ListPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDissapear()
    func didSelectRow(section: Int, row: Int)
}

protocol ListViewProtocol: Coverable, ErrorPresenter {
    var tableViewModel: [ListViewSection] { get set }
}
