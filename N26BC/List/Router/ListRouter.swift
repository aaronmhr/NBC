//
//  ListRouter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class ListRouter {
    weak var view: ListViewController!
    
    init(_ view: ListViewController) {
        self.view = view
    }
    
    static func assembleModule() -> UIViewController {
        let viewController = defaultViewController
        let interactor = ListInteractor()
        let router = ListRouter(viewController)
        let presenter = ListPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        return viewController
    }
    
    private static var defaultViewController: ListViewController {
        let storyaboard = UIStoryboard(name: Constants.storyboard, bundle: nil)
        guard let viewController = storyaboard.instantiateViewController(withIdentifier: Constants.viewControllerID) as? ListViewController else {
            fatalError("Failed to instantiate \(Constants.viewControllerID)")
        }
        return viewController
    }
}

extension ListRouter: ListRouterProtocol { }

extension ListRouter {
    private enum Constants {
        static let storyboard = "List"
        static let viewControllerID = String(describing: ListViewController.self)
    }
}
