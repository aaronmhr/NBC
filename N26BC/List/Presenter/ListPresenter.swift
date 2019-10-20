//
//  ListPresenter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons

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
        view.addFullScreenLoadingView()
        interactor.retrieveHistoricalData { [weak self] result in
            DispatchQueue.main.async {
                self?.view.removeFullScreenLoadingView()
            }
            switch result {
            case .success(let historicalPrices):
                self?.secondSection = HistoricalTableViewModel.makeSectionViewModel(from: historicalPrices, title: Localizables.secondSection, type: .historical)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view.showError(error: error, action: self?.restartLoading)
                }
            }
        }
    }
    
    private func restartLoading() {
        stopRetreavingTodayData()
        viewDidLoad()
        viewWillAppear()
    }
    
    func viewWillAppear() {
        self.interactor.retrieveTodayData { [weak self] result in
            switch result {
            case .success(let todayPrices):
                self?.firstSection = TodayTableViewModel.makeSectionViewModel(from: [todayPrices], title: Localizables.firstSection, type: .today)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view.showError(error: error, action: self?.restartLoading)
                }
            }
        }
    }
    
    func viewWillDissapear() {
        stopRetreavingTodayData()
    }
    
    private func stopRetreavingTodayData() {
        interactor.stopRetreavingTodayData()
    }
    
    private enum Localizables {
        static let firstSection = "Today"
        static let secondSection = "Historical"
    }
}
