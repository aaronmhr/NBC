//
//  ListPresenter.swift
//  NBC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Valuation

final class ListPresenter {
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    weak var view: ListViewProtocol!
    
    private var firstSectionModels: [Valuation] = []
    private var secondSectionModels: [Valuation] = []
    
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
                self?.secondSectionModels = historicalPrices
                self?.secondSection = HistoricalTableViewModel.makeSectionViewModel(from: historicalPrices, title: Localizables.secondSection)
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
                self?.firstSectionModels = [todayPrices]
                self?.firstSection = TodayTableViewModel.makeSectionViewModel(from: [todayPrices], title: Localizables.firstSection)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view.showError(error: error, action: self?.restartLoading)
                }
            }
        }
    }
    
    func didSelectRow(section: Int, row: Int) {
        let valuation: Valuation?
        switch section {
        case 0:
            guard firstSectionModels.indices.contains(row) else { return }
            valuation = firstSectionModels[row]
        case 1:
            guard secondSectionModels.indices.contains(row) else { return }
            valuation = secondSectionModels[row]
        default:
            valuation = nil
        }
        router.showDetailView(for: valuation)
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
