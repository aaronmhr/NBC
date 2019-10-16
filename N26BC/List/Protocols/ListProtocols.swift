//
//  ListProtocols.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

protocol ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[HistoricalPrice], ShowableError>) -> Void)
}

protocol ListRouterProtocol {
    
}

protocol ListPresenterProtocol {
    func viewDidLoad()
}

protocol ListViewProtocol: class {
    var pricesModel: [PricesViewModel] { get set }
}
