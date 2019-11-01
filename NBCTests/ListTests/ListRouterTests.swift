//
//  ListRouterTests.swift
//  NBCTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import NBC

class ListRouterTests: XCTestCase {
    func testAssembleModule_returnsViewController() {
        XCTAssertNotNil(ListRouter.assembleModule())
    }
    
    func testAssembleModule_returnsListViewController() {
        let viewController = ListRouter.assembleModule()
        XCTAssertTrue(viewController is ListViewController)
    }
    
    func testAssembleModule_producessFullyFunctionalViperModule() {
        // MARK: VIPER assumptions
        let assembledView = ListRouter.assembleModule()
        
        let view =  assembledView as? ListViewController
        let conformingProtocolView = assembledView as? ListViewProtocol
        XCTAssertNotNil(view, "assembledView is not nil and is ListViewController")
        XCTAssertNotNil(conformingProtocolView, "assembledView conforms to ListViewProtocol by design")
        
        let presenter = view?.presenter as? ListPresenter
        let conformingProtocolPresenter = view?.presenter
        XCTAssertNotNil(presenter, "view contains non-nil ListPresenter")
        XCTAssertNotNil(conformingProtocolPresenter, "presenter conforms to ListPresenterProtocol by design")
        
        XCTAssertNotNil(presenter?.view, "presenter contains non-strong referenced View that conforms to ListViewProtocol by design")
        
        let interactor = presenter?.interactor
        XCTAssertNotNil(interactor, "presenter contains Interator that conforms to ListInteractorProtocol")
        
        let router = presenter?.router as? ListRouter
        XCTAssertNotNil(router, "presenter contains Router that conforms to ListRouterProtocol")
        XCTAssertNotNil(router?.view, "router contains view that conforms to ListViewProtocol")
    }
    
    func testDefaultViewController_InstantiatesListViewController() {
        let viewController = ListRouter.defaultViewController(for: ListViewController.self)
        XCTAssertNotNil(viewController)
    }
}


