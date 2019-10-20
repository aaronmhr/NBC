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
    
    lazy var fullScreenView: UIView? = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()

    var tableViewModel: [ListViewSection] = [] {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDissapear()
    }
}

extension ListViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: ListViewProtocol { 
    func addFullScreenLoadingView() {
        DispatchQueue.main.async {
            guard let view = self.fullScreenView else { return }
            self.tableView.isUserInteractionEnabled = false
            self.navigationController?.navigationBar.addSubview(view)
        }
    }
    
    func removeFullScreenLoadingView() {
        DispatchQueue.main.async {
            guard let view = self.fullScreenView else { return }
            self.tableView.isUserInteractionEnabled = true
            view.removeFromSuperview()
        }
    }
}
//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableViewModel.indices.contains(section) else { return 0 }
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
        guard tableViewModel.indices.contains(indexPath.section) else { return UITableViewCell() }
        guard tableViewModel[indexPath.section].rows.indices.contains(indexPath.row) else { return UITableViewCell() }
        let currentPrice = tableViewModel[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = currentPrice.price
        cell.detailTextLabel?.text = currentPrice.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableViewModel.indices.contains(section) else { return nil }
        let currentSection = tableViewModel[section]
        let header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        header.textLabel?.text = currentSection.title
        return header
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(section: indexPath.section, row: indexPath.row)
    }
}
