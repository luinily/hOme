//
//  CommandTimeTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme
//@testable import temp

class CommandTimeTests: XCTestCase {
	var time: CommandTime?
	
	override func setUp() {
		super.setUp()
		time = CommandTime()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	//MARK: - hours
	func testHours_1() {
		time?.hours = 1
		XCTAssertEqual(time?.hours, 1)
	}
	
	func testHours_23() {
		time?.hours = 23
		XCTAssertEqual(time?.hours, 23)
	}
	
	func testHours_24() {
		time?.hours = 60
		XCTAssertEqual(time?.hours, 23)
	}
	
	func testHours_42() {
		time?.hours = 60
		XCTAssertEqual(time?.hours, 23)
	}

	func testHours_minus1() {
		time?.hours = -1
		XCTAssertEqual(time?.hours, 0)
	}
	
	func testHours_minus42() {
		time?.hours = -42
		XCTAssertEqual(time?.hours, 0)
	}
	
	//Mark: - minutes
	func testMinutes_1() {
		time?.minutes = 1
		XCTAssertEqual(time?.minutes, 1)
	}
	
	func testMinutes_59() {
		time?.minutes = 59
		XCTAssertEqual(time?.minutes, 59)
	}
	
	func testMinutes_60() {
		time?.minutes = 60
		XCTAssertEqual(time?.minutes, 59)
	}
	
	func testMinutes_75() {
		time?.minutes = 75
		XCTAssertEqual(time?.minutes, 59)
	}
	
	func testMinutes_minus1() {
		time?.minutes = -1
		XCTAssertEqual(time?.minutes, 0)
	}
	
	func testMinutes_minus42() {
		time?.minutes = -42
		XCTAssertEqual(time?.minutes, 0)
	}
	
	//MARK: - string
	func test_timeString_0120() {
		time?.hours = 1
		time?.minutes = 20
		XCTAssertEqual(time?.time, "01:20")
	}
	
	func test_timeString_2301() {
		time?.hours = 23
		time?.minutes = 1
		XCTAssertEqual(time?.time, "23:01")
	}
	
	func test_StringToTime_2301() {
		time?.time = "23:01"
		XCTAssertEqual(time?.hours, 23)
		XCTAssertEqual(time?.minutes, 1)
		
	}
	
	func test_StringToTime_4272() {
		time?.time = "42:72"
		XCTAssertEqual(time?.hours, 23)
		XCTAssertEqual(time?.minutes, 59)
		
	}
	
	func test_StringToTime_noHours() {
		time?.time = ":01"
		XCTAssertEqual(time?.hours, 0)
		XCTAssertEqual(time?.minutes, 1)
	}
	
	func test_StringToTime_noMinutes() {
		time?.time = "12:"
		XCTAssertEqual(time?.hours, 12)
		XCTAssertEqual(time?.minutes, 0)
	}
	
	func test_StringToTime_minusHours() {
		time?.time = "-10:20"
		XCTAssertEqual(time?.hours, 0)
		XCTAssertEqual(time?.minutes, 20)
	}
	
	func test_StringToTime_minusMinutes() {
		time?.time = "10:-20"
		XCTAssertEqual(time?.hours, 10)
		XCTAssertEqual(time?.minutes, 0)
	}
	
	func test_StringToTime_noCollon() {
		time?.time = "1020"
		XCTAssertEqual(time?.hours, 0)
		XCTAssertEqual(time?.minutes, 0)
	}
}
