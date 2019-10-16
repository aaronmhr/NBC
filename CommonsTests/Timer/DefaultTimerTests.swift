//
//  DefaultTimerTests.swift
//  CommonsTests
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import Commons

class DefaultTimerTests: XCTestCase {
    
    weak var weakSUT: DefaultTimer?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT)
    }
    func testInit_internalTimerIsNilWhenInstantiated() {
        var times = 0
        let sut = makeSUT()
        let exp = expectation(description: "timer")
        XCTAssertNil(sut.timer)
        sut.schedule(timeInterval: 1, repeats: false, completionBlock: {
            times += 1
            exp.fulfill()
        })
        sut.fire()
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(sut.timer)
        XCTAssertEqual(times, 1)
        sut.invalidate()
        XCTAssertNil(sut.timer)
    }
    
    func testSchedule_schedulesOperationAsAndReapeatsIt_asRequired() {
        var times = 0
        let expectedTimes = 2
        let sut = makeSUT()
        let exp = expectation(description: "timer")
        let closure: DefaultTimer.CompletionBlock = {
            times += 1
            times == expectedTimes ? exp.fulfill() : ()
        }
        sut.schedule(timeInterval: 0.3, repeats: true, completionBlock: closure)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(times, expectedTimes)
    }
    
    // MARK: - Helpers
    func makeSUT() -> DefaultTimer {
        let sut = DefaultTimer()
        weakSUT = sut
        return sut
    }
}
