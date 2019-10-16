//
//  ListViewController.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol!
    @IBOutlet private(set) var tableView: UITableView!
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pricesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let day = pricesModel[indexPath.row]
        cell.textLabel?.text = day.price
        cell.detailTextLabel?.text = day.date
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {

}
