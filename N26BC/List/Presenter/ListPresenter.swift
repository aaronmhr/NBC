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
    
    private var firstSection: TodayTableViewModel? {
        didSet {
            buildNewViewModel(with: firstSection, and: secondSection)
        }
    }
    private var secondSection: HistoricalTableViewModel? {
        didSet {
            buildNewViewModel(with: firstSection, and: secondSection)
        }
    }
    
    //    Try with mapper order at the interactor
    private func buildNewViewModel(with firstSection: ListViewSection?, and secondSection: ListViewSection?) {
        view.tableViewModel = [firstSection, secondSection].compactMap { $0 }
    }
    
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
                self?.secondSection = HistoricalTableViewModel.makeSectionViewModel(from: historicalPrices, title: Localizables.secondSection, type: .historical)
            case .failure(let error):
                print("Error")
            }
        }
        
        
    }
    
    func viewWillAppear() {
        interactor.retrieveCurrentData { [weak self] result in
            switch result {
            case .success(let todayPrices):
                self?.firstSection = TodayTableViewModel.makeSectionViewModel(from: [todayPrices], title: Localizables.firstSection, type: .today)
            case .failure(let error):
                print("Error")
            }
        }
    }
    
    func viewWillDissapear() {
        //        interactor.invalidateTimer
    }
    
    private enum Localizables {
        static let firstSection = "Today"
        static let secondSection = "Historical"
    }
}

struct PricesViewModel {
    let date: String
    let price: String
}
