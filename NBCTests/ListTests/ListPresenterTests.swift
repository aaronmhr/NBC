//
//  ListPresenterTests.swift
//  NBC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
import Valuation
@testable import NBC

class ListPresenterTestsTests: XCTestCase {
    func testViewDidLoad_whenInteractorReturnsResultErrorNetworking() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.resultHistorical = .failure(.networking)
        sut.viewDidLoad()
        XCTAssertTrue(view.isAddFullScreenLoadingViewTriggered)
        XCTAssertTrue(interactor.isRetrievingHistoricalData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isRemoveFullScreenLoadingViewTriggered)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_whenInteractorReturnsResultErrorOther() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.resultHistorical = .failure(.other)
        sut.viewDidLoad()
        XCTAssertTrue(view.isAddFullScreenLoadingViewTriggered)
        XCTAssertTrue(interactor.isRetrievingHistoricalData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isRemoveFullScreenLoadingViewTriggered)
            XCTAssertFalse(view.isViewModelUpdated)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_whenInteractorReturnsSuccessEmpty() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.resultHistorical = .success([])
        sut.viewDidLoad()
        XCTAssertTrue(view.isAddFullScreenLoadingViewTriggered)
        XCTAssertTrue(interactor.isRetrievingHistoricalData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isRemoveFullScreenLoadingViewTriggered)
            XCTAssertTrue(view.isViewModelUpdated)
            XCTAssertFalse(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_whenInteractorReturnsSuccessValuationArray() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        let valuation1 = Valuation(date: Date(), price: 10, currency: .euro)
        let valuation2 = Valuation(date: Date(), price: 9, currency: .euro)
        let valuationArray = [valuation1, valuation2]
        interactor.resultHistorical = .success(valuationArray)
        sut.viewDidLoad()
        XCTAssertTrue(view.isAddFullScreenLoadingViewTriggered)
        XCTAssertTrue(interactor.isRetrievingHistoricalData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isRemoveFullScreenLoadingViewTriggered)
            XCTAssertTrue(view.isViewModelUpdated)
            XCTAssertEqual(view.tableViewModel[0].rows.count, valuationArray.count)
            XCTAssertFalse(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewWillAppear_whenInteractorReturnsResultErrorNetworking() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.resultToday = .failure(.networking)
        sut.viewWillAppear()
        XCTAssertTrue(interactor.isRetrievingTodayData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewWillAppear_whenInteractorReturnsResultErrorOther() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        interactor.resultToday = .failure(.other)
        sut.viewWillAppear()
        XCTAssertTrue(interactor.isRetrievingTodayData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertFalse(view.isViewModelUpdated)
            XCTAssertTrue(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewWillAppear_whenInteractorReturnsSuccessValuation() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, _) = makeSUT()
        let valuation = Valuation(date: Date(), price: 10, currency: .euro)
        interactor.resultToday = .success(valuation)
        sut.viewWillAppear()
        XCTAssertTrue(interactor.isRetrievingTodayData)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isViewModelUpdated)
            XCTAssertEqual(view.tableViewModel[0].rows.count, [valuation].count)
            XCTAssertFalse(view.isShowingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewWillDissappear() {
        let (sut, _, interactor, _) = makeSUT()
        sut.viewWillDissapear()
        XCTAssertTrue(interactor.isStopRetrievingTodayData)
    }
    
    func testShowDetailViewSecondSection() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, router) = makeSUT()
        let valuation = Valuation(date: Date(), price: 10, currency: .euro)
        interactor.resultHistorical = .success([valuation])
        sut.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isViewModelUpdated)
            expectation.fulfill()
            sut.didSelectRow(section: 1, row: 0)
            XCTAssertTrue(router.shouldShowDetailView)
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testShowDetailViewFirstSection() {
        let expectation = XCTestExpectation(description: "Presenter")
        let (sut, view, interactor, router) = makeSUT()
        let valuation = Valuation(date: Date(), price: 10, currency: .euro)
        interactor.resultToday = .success(valuation)
        sut.viewWillAppear()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(view.isViewModelUpdated)
            expectation.fulfill()
            sut.didSelectRow(section: 0, row: 0)
            XCTAssertTrue(router.shouldShowDetailView)
        }
        wait(for: [expectation], timeout: 2.0)
    }
    // MARK: - Helpers
    func makeSUT() -> (ListPresenterProtocol, TestingView, TestingInteractor, TestingRouter) {
        let view = TestingView()
        let interactor = TestingInteractor()
        let router = TestingRouter()
        let sut = ListPresenter(view: view, interactor: interactor, router: router)
        return (sut, view, interactor, router)
    }
    
    final class TestingView: ListViewProtocol {
        var isAddFullScreenLoadingViewTriggered = false
        var isRemoveFullScreenLoadingViewTriggered = false
        var isShowingError = false
        var isViewModelUpdated = false
        
        
        var tableViewModel: [ListViewSection] = [] {
            didSet { isViewModelUpdated = true }
        }
        
        func addFullScreenLoadingView() {
            isAddFullScreenLoadingViewTriggered = true
        }
        
        func removeFullScreenLoadingView() {
            isRemoveFullScreenLoadingViewTriggered = true
        }
        
        func showError(error: Error, action: (() -> Void)?) {
            isShowingError = true
        }
    }
    
    final class TestingInteractor: ListInteractorProtocol {
        var isRetrievingHistoricalData = false
        var isRetrievingTodayData = false
        var isStopRetrievingTodayData = false
        
        var resultHistorical: Result<[Valuation], BCError> = .failure(.networking)
        var resultToday: Result<Valuation, BCError> = .failure(.networking)
        
        func retrieveHistoricalData(completion: @escaping (Result<[Valuation], BCError>) -> Void) {
            isRetrievingHistoricalData = true
            completion(resultHistorical)
        }
        
        func retrieveTodayData(completion: @escaping (Result<Valuation, BCError>) -> Void) {
            isRetrievingTodayData = true
            completion(resultToday)
        }
        
        func stopRetreavingTodayData() {
            isStopRetrievingTodayData = true
        }
    }
    
    final class TestingRouter: ListRouterProtocol {
        var shouldShowDetailView = false
        
        func showDetailView(for valuation: Valuation?) {
            shouldShowDetailView = true
        }
    }
}
