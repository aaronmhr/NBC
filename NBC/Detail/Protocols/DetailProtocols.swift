//
//  DetailProtocols.swift
//  NBC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Networking
import Valuation

protocol DetailInteractorProtocol {
    var valuation: Valuation { get }
    func retrieveData(for currency: Currency, date: Date, completion: @escaping (Result<Valuation, BCError>) -> Void)
}

protocol DetailRouterProtocol {
    func goBack(animated: Bool)
}

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func backButtonDidPress()
}

protocol DetailViewProtocol: ErrorPresenter {
    var detailViewModel: DetailViewModel? { get set }
    func backButtonAction()
}
