//
//  TodayRouter.swift
//  NBC
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class TodayRouter {
    weak var view: TodayViewController!

    init(with view: TodayViewController) {
        self.view = view
    }

    static func assembleModule(viewController: TodayViewController) {
        let router = TodayRouter(with: viewController)

        let interactor = TodayInteractorComposer.compose()
        let presenter = TodayPresenter(withView: viewController, interactor: interactor, router: router)

        viewController.presenter = presenter
    }

}

extension TodayRouter: TodayRouterProtocol {

}
