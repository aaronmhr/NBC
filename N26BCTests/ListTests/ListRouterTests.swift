//
//  ListRouterTests.swift
//  N26BCTests
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import XCTest
@testable import N26BC

class ListRouterTests: XCTestCase {
    func testAssembleModule_returnsViewController() {
        XCTAssertNotNil(ListRouter.assembleModule())
    }
}


