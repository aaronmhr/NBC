//
//  DetailViewControllerTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import N26BC

class DetailViewControllerTests: XCTestCase {
    func testViewDidLoad_callsPresenterViewDidLoad() {
        let (sut, presenterSpy) = makeSUT()
        
        givenViewDidLoadOn(sut)
        
        XCTAssertTrue(presenterSpy.wasViewDidLoadCalled)
    }
    
    func testBackButtonAction_callsPresenterBackButtonDidPress() {
        let (sut, presenterSpy) = makeSUT()
        
        sut.backButtonAction()
        
        XCTAssertTrue(presenterSpy.wasBackButtonPressed)
    }
    
    func testDetailViewModel_trigersUIUpdate() {
        let (sut, _) = makeSUT()
        givenViewDidLoadOn(sut)
        
        let viewModel = DetailViewModel(title: "A", euro: "B", dollar: "C", pound: "D")

        sut.detailViewModel = viewModel
        
        XCTAssertEqual(sut.titleLabel.text, "A")
        XCTAssertEqual(sut.euroLabel.text, "B")
        XCTAssertEqual(sut.dollarLabel.text, "C")
        XCTAssertEqual(sut.poundLabel.text, "D")
    }
    
    // MARK: - Helpers
    private func givenViewDidLoadOn(_ sut: DetailViewController) {
        sut.loadViewIfNeeded()
    }
    
    func makeSUT() -> (viewController: DetailViewController, presenter: DetailPresenterSpy) {
        let viewController = DetailRouter.defaultViewController(for: DetailViewController.self)
        let presenterSpy = DetailPresenterSpy()
        viewController.presenter = presenterSpy
        return (viewController, presenterSpy)
    }
}

class DetailPresenterSpy: DetailPresenterProtocol {
    var wasBackButtonPressed = false
    var wasViewDidLoadCalled = false
    
    func viewDidLoad() {
        wasViewDidLoadCalled = true
    }
    
    func backButtonDidPress() {
        wasBackButtonPressed = true
    }
    
}
