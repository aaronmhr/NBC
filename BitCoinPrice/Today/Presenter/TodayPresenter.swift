//
//  TodayPresenter.swift
//  NBC
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Valuation

final class TodayPresenter {
    let router: TodayRouterProtocol
    let interactor: TodayInteractorProtocol
    weak var view: TodayViewProtocol!
    
    init(withView view: TodayViewProtocol, interactor: TodayInteractorProtocol, router: TodayRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodayPresenter: TodayPresenterProtocol {
    func viewWillAppear() {
        view.viewModel = nil
        self.interactor.retrieveTodayData { [weak self] result in
            switch result {
            case .success(let today):
                self?.view.viewModel = self?.map(price: today.price, currency: today.currency)
            case .failure:
                self?.view.viewModel = "Something went wrong! 😔"
            }
        }
    }
    
    private func map(price: Double, currency: Currency) -> String {
        let price = "1BTC = \(price) \(currency.rawValue)"
        return price
    }
}
