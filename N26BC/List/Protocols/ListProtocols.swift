//
//  ListProtocols.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

protocol ListInteractorProtocol {
    func retrieveHistoricalData(completion: @escaping (Result<[Valuation], ShowableError>) -> Void)
    func retrieveCurrentData(completion: @escaping (Result<Valuation, ShowableError>) -> Void)
}

protocol ListRouterProtocol {
    
}

protocol ListPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDissapear()
}

protocol ListViewProtocol: class {
    var tableViewModel: [ListViewSection] { get set }
}
