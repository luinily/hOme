//
//  MathUtilsTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class CommandMathUtilsTests: XCTestCase {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testEnsureRange_lower() {
		let result = ensureRange(0, min: 1, max: 2)
		XCTAssertEqual(result, 1)
	}
	
	func testEnsureRange_higher() {
		let result = ensureRange(2.4, min: 1.1, max: 2)
		XCTAssertEqual(result, 2)
	}
	
	func testEnsureRange_inRange() {
		let result = ensureRange(2.5, min: 2, max: 3)
		XCTAssertEqual(result, 2.5)
	}
	
	
}
