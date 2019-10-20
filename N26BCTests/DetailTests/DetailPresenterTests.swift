//
//  DetailPresenterTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Valuation
@testable import N26BC

class DetailPresenterTestsTests: XCTestCase {
    func testViewDidLoad_whenInteractorReturnsResultErrorNetworking() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.result = [.failure(.networking), .failure(.networking), .failure(.networking)]
        sut.viewDidLoad()
        XCTAssertTrue(interactor.isRetrievingData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertEqual(interactor.count, 3)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_whenInteractorReturnsResultErrorOther() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.result = [.failure(.other), .failure(.other), .failure(.other)]
        sut.viewDidLoad()
        XCTAssertTrue(interactor.isRetrievingData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertEqual(interactor.count, 3)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_retrievesData() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        let v1 = Valuation(date: Date(), price: 1, currency: .euro)
        let v2 = Valuation(date: Date(), price: 10, currency: .dollar)
        let v3 = Valuation(date: Date(), price: 100, currency: .pound)
        interactor.result = [.success(v1), .success(v2), .success(v3)]
        sut.viewDidLoad()
        XCTAssertTrue(interactor.isRetrievingData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertEqual(interactor.count, 3)
            XCTAssertFalse(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_retrievesDataButPresentsErrorIfCallFails() {
        let expectation = XCTestExpectation(description: "Presenter")
        let v1 = Valuation(date: Date(), price: 1, currency: .euro)
        let v2 = Valuation(date: Date(), price: 10, currency: .dollar)
        let (sut, view, interactor, _) = makeSUT()
        interactor.result = [.success(v1), .success(v2), .failure(.other)]
        sut.viewDidLoad()
        XCTAssertTrue(interactor.isRetrievingData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertEqual(interactor.count, 3)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Helpers
    func makeSUT() -> (DetailPresenterProtocol, TestingView, TestingInteractor, TestingRouter) {
        let view = TestingView()
        let interactor = TestingInteractor()
        let router = TestingRouter()
        let sut = DetailPresenter(view: view, interactor: interactor, router: router)
        return (sut, view, interactor, router)
    }
    
    final class TestingView: DetailViewProtocol {
        var isShowingError = false
        var isBackButtonActionTriggered = false
        
        var detailViewModel: DetailViewModel?
        
        func backButtonAction() {
            isBackButtonActionTriggered = true
        }
        
        func showError(error: Error, action: (() -> Void)?) {
            isShowingError = true
            action?()
        }
    }
    
    final class TestingInteractor: DetailInteractorProtocol {
        var isRetrievingData = false
        var count = 0
        var result: [Result<Valuation, N26BCError>] = [.failure(.networking)]
        
        var valuation: Valuation = Valuation(date: Date(), price: 1.0, currency: .euro)
        
        func retrieveData(for currency: Currency, date: Date, completion: @escaping (Result<Valuation, N26BCError>) -> Void) {
            isRetrievingData = true
            completion(result[count])
            count += 1
        }
    }
    
    final class TestingRouter: DetailRouterProtocol {
        var isGoBackTriggered = false
        
        func goBack(animated: Bool) {
            isGoBackTriggered = true
        }
    }
}
