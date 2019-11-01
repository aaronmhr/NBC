//
//  TodayViewController.swift
//  NBC
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
    var presenter: TodayPresenterProtocol!
    @IBOutlet private(set) var label: UILabel!
    
    var viewModel: String? {
        didSet { label.text = viewModel}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TodayRouter.assembleModule(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension TodayViewController: TodayViewProtocol {

}
