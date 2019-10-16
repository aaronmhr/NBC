//
//  ListViewController.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit
/* Alerta */
import Commons


final class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol!
    @IBOutlet private(set) var tableView: UITableView!
    
    var tableViewModel: [ListViewSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var pricesModel: [PricesViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension ListViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: ListViewProtocol { }

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = tableViewModel[section]
        switch currentSection.sectionType {
        case .historical:
            return currentSection.rows.count
        case .today:
            return currentSection.rows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "price")
        let currentPrice = tableViewModel[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = currentPrice.price
        cell.detailTextLabel?.text = currentPrice.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = tableViewModel[section]
        let header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        header.textLabel?.text = currentSection.title
        return header
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {

}

enum ListSectionType: Int {
    case today
    case historical
}

protocol ListViewSection {
    var title: String { get }
    var rows: [PricesViewModel] { get }
    var sectionType: ListSectionType { get }
}


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
            let date: String = $0.date.toStringWithFormat("MM-dd-yyyy")
            let price = "1BTC = \($0.price) \($0.currency.rawValue)"
            return PricesViewModel(date: date, price: price)
        }
        
        return TodayTableViewModel(title: title, rows: pricesModel)
    }
}


struct HistoricalTableViewModel: ListViewSection {
    let title: String
    let rows: [PricesViewModel]
    let sectionType: ListSectionType = .historical
    
    init(title: String, rows: [PricesViewModel]) {
        self.title = title
        self.rows = rows
    }
    
    static func makeSectionViewModel(from model: [Valuation], title: String, type: ListSectionType) -> HistoricalTableViewModel {
        
        let pricesModel: [PricesViewModel] = model.map {
            let date: String = $0.date.toStringWithFormat("MM-dd-yyyy")
            let price = "1BTC = \($0.price) \($0.currency.rawValue)"
            return PricesViewModel(date: date, price: price)
        }
        
        return HistoricalTableViewModel(title: title, rows: pricesModel)
    }
}
