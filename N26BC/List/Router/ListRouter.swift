//
//  ListRouter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class ListRouter: StoryboardInstantiator {
    weak var view: ListViewController!
    
    init(_ view: ListViewController) {
        self.view = view
    }
    
    static func assembleModule() -> UIViewController {
        let viewController = defaultViewController(for: ListViewController.self)
        let interactor = ListInteractorComposer.compose()
        let router = ListRouter(viewController)
        let presenter = ListPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        return viewController
    }
}

extension ListRouter: ListRouterProtocol {
    func showDetailView(for valuation: Valuation?) {
        guard let valuation = valuation else { return }
    }
}
