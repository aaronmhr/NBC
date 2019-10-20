//
//  DetailViewController.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var euroLabel: UILabel!
    @IBOutlet private var dollarLabel: UILabel!
    @IBOutlet private var poundLabel: UILabel!
    
    var detailViewModel: DetailViewModel? {
        didSet {
            titleLabel.text = detailViewModel?.title
            euroLabel.text = detailViewModel?.euro
            dollarLabel.text = detailViewModel?.dollar
            poundLabel.text = detailViewModel?.pound
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Backy", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = backButton
        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailViewProtocol {
    @objc func backButtonAction() {
        presenter.backButtonDidPress()
    }
}
