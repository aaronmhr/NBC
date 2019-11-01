//
//  DetailRouterTests.swift
//  NBCTests
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Valuation
@testable import NBC

class DetailRouterTests: XCTestCase {
    func testAssembleModule_returnsViewController() {
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        XCTAssertNotNil(DetailRouter.assembleModule(valuation: valuation))
    }
    
    func testAssembleModule_returnsDetailViewController() {
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        let viewController = DetailRouter.assembleModule(valuation: valuation)
        XCTAssertTrue(viewController is DetailViewController)
    }
    
    func testAssembleModule_producessFullyFunctionalViperModule() {
        // MARK: VIPER assumptions
        let valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        let assembledView = DetailRouter.assembleModule(valuation: valuation)
        
        let view =  assembledView as? DetailViewController
        let conformingProtocolView = assembledView as? DetailViewProtocol
        XCTAssertNotNil(view, "assembledView is not nil and is DetailViewController")
        XCTAssertNotNil(conformingProtocolView, "assembledView conforms to DetailViewProtocol by design")
        
        let presenter = view?.presenter as? DetailPresenter
        let conformingProtocolPresenter = view?.presenter
        XCTAssertNotNil(presenter, "view contains non-nil DetailPresenter")
        XCTAssertNotNil(conformingProtocolPresenter, "presenter conforms to DetailPresenterProtocol by design")
        
        XCTAssertNotNil(presenter?.view, "presenter contains non-strong referenced View that conforms to DetailViewProtocol by design")
        
        let interactor = presenter?.interactor
        XCTAssertNotNil(interactor, "presenter contains Interator that conforms to DetailInteractorProtocol")
        
        let router = presenter?.router as? DetailRouter
        XCTAssertNotNil(router, "presenter contains Router that conforms to DetailRouterProtocol")
        XCTAssertNotNil(router?.view, "router contains view that conforms to DetailViewProtocol")
    }
    
    func testDefaultViewController_InstantiatesDetailViewController() {
        let viewController = DetailRouter.defaultViewController(for: DetailViewController.self)
        XCTAssertNotNil(viewController)
    }
}
