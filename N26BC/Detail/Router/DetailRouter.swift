//
//  DetailRouter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class DetailRouter {
    weak var view: DetailViewController!

    init(_ view: DetailViewController) {
        self.view = view
    }

    static func assembleModule() -> UIViewController {
        
        return UIViewController()
    }
}

extension DetailRouter: DetailRouterProtocol {

}
