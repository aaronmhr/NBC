//
//  DetailPresenter.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Commons

final class DetailPresenter {
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    weak var view: DetailViewProtocol!

    init(view: DetailViewProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DetailPresenter: DetailPresenterProtocol {

}
