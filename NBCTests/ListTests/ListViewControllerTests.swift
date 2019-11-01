//
//  ListViewControllerTests.swift
//  NBCTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import NBC

class ListViewControllerTests: XCTestCase {
    func testViewDidLoad_callsPresenterViewDidLoad() {
        let (sut, presenterSpy) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenterSpy.isViewDidLoadCalled)
        
        sut.beginAppearanceTransition(true, animated: true)
        
        XCTAssertTrue(presenterSpy.isViewWillAppearCalled)
        
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
    
    func testTableViewDoesNotDisplayAnyCellPriorToUpdate() {
        let (sut,_) = makeSUT()
        
        givenViewDidLoadOn(sut)
        
        XCTAssertTrue(sut.tableView.visibleCells.isEmpty)
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
    var isViewWillAppearCalled = false
    var isWillDisappearCalled = false
    var isDidSelectRowCalled = false
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func viewWillAppear() {
        isViewWillAppearCalled = true
    }
    
    func viewWillDissapear() {
        isWillDisappearCalled = true
    }
    
    func didSelectRow(section: Int, row: Int) {
        isDidSelectRowCalled = true
    }
}
