//
//  DetailPresenter.swift
//  NBC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Valuation

final class DetailPresenter {
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    weak var view: DetailViewProtocol!
    
    private var viewModel: DetailViewModel = DetailViewModel(title: nil, euro: nil, dollar: nil, pound: nil) {
        didSet {
            view.detailViewModel = viewModel
        }
    }
    
    init(view: DetailViewProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        viewModel.title = mapDate(date: interactor.valuation.date)
        loadData()
    }
    
    private func loadData() {
        [Currency.euro, .dollar, .pound].forEach { currency in
            interactor.retrieveData(for: currency, date: interactor.valuation.date) { [weak self] result in
                switch result {
                case .success(let valuation):
                    
                    self?.handleSuccess(valuation: valuation, currency: currency)
                case .failure(let error):
                    self?.view.showError(error: error) {
                        self?.backButtonDidPress()
                    }
                }
            }
        }
    }
    
    
    private func handleSuccess(valuation: Valuation, currency: Currency) {
        switch currency {
        case .euro:
            viewModel.euro = mapPrice(price: valuation.price, currency: currency)
        case .dollar:
            viewModel.dollar = mapPrice(price: valuation.price, currency: currency)
        case .pound:
            viewModel.pound = mapPrice(price: valuation.price, currency: currency)
        default:
            break
        }
    }
    
    private func mapPrice(price: Double, currency: Currency) -> String? {
        return "1BTC = \(price) \(currency.rawValue)"
    }
    
    private func mapDate(date: Date) -> String? {
        return date.toStringWithFormat("MM-dd-yyyy")
    }
    
    func backButtonDidPress() {
        router.goBack(animated: true)
    }
}

struct DetailViewModel {
    var title: String?
    var euro: String?
    var dollar: String?
    var pound: String?
}
