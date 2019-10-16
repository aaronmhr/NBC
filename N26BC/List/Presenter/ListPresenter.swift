//
//  ListPresenter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

final class ListPresenter {
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    weak var view: ListViewProtocol!
    
    init(view: ListViewProtocol, interactor: ListInteractorProtocol, router: ListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ListPresenter: ListPresenterProtocol {
    func viewDidLoad() {
        interactor.retrieveHistoricalData { [weak self] result in
            switch result {
            case .success(let historicalPrices):
                self?.view.pricesModel = historicalPrices.map {
                    let date = "\($0.date)"
                    let price = "1BTC = \($0.price) \($0.currency.rawValue)"
                    return PricesViewModel(date: date, price: price)
                }
            case .failure(let error):
                self?.view.pricesModel = []
            }
        }
    }
}

struct PricesViewModel {
    let date: String
    let price: String
}
