//
//  DetailRouter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class DetailRouter: StoryboardInstantiator {
    weak var view: DetailViewController!

    init(_ view: DetailViewController) {
        self.view = view
    }

    static func assembleModule() -> UIViewController {
        let viewController = defaultViewController(for: DetailViewController.self)
        let interactor = DetailInteractorComposer.compose()
        let router = DetailRouter(viewController)
        let presenter = DetailPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        return viewController
    }
}

extension DetailRouter: DetailRouterProtocol {

}
