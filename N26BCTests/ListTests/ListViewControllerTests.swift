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
        let delegatePriorToViewDidLoad = sut.tableView?.delegate
        let dataSourcePriorToViewDidLoad = sut.tableView?.dataSource
        XCTAssertNil(delegatePriorToViewDidLoad)
        XCTAssertNil(dataSourcePriorToViewDidLoad)
        
        givenViewDidLoadOn(sut)
        
        let delegate = sut.tableView?.delegate
        let dataSource = sut.tableView?.dataSource
        XCTAssertTrue(sut === dataSource, "ViewController is tableview data source")
        XCTAssertTrue(sut === delegate, "ViewController is tableview delegate")
    }
    
    
    
    // MARK: - Helpers
    private func givenViewDidLoadOn(_ sut: ListViewController) {
        sut.loadViewIfNeeded()
    }
    
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
