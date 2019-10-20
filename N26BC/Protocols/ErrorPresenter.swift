//
//  ErrorPresenter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

protocol ErrorPresenter: class {
    func showError(error: Error, action: (() -> Void)?)
}

extension ErrorPresenter where Self: UIViewController {
    func showError(error: Error, action: (() -> Void)?) {
        let alert = UIAlertController(title: Constants.error, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.button, style: .default, handler: { _ in
            action?()
        }))
        present(alert, animated: true)
    }
}

private enum Constants {
    static let error = "There's been an error, do you want to retry?"
    static let button = "OK"
}
