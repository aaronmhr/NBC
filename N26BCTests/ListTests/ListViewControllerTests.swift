//
//  ListViewControllerTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import N26BC

class ListViewControllerTests: XCTestCase {
    func testViewDidLoad_callsPresenterViewDidLoad() {
        let (sut, presenterSpy) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenterSpy.isViewDidLoadCalled)
    }
    
    func testViewDidLoad_setsUpTableViewDelegateAndDataSource() {
        let (sut,_) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tableView?.delegate)
        XCTAssertNotNil(sut.tableView?.dataSource)
    }
    
    
    
    // MARK: - Helpers
    func makeSUT() -> (viewController: ListViewController, presenter: ListPresenterSpy) {
        let viewController = ListRouter.defaultViewController(for: ListViewController.self)
        let presenterSpy = ListPresenterSpy()
        viewController.presenter = presenterSpy
        return (viewController, presenterSpy)
    }
}

class ListPresenterSpy: ListPresenterProtocol {
    var isViewDidLoadCalled = false
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
}
