//
//  DeviceInfoTests.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/03.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class DeviceInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testInit_InitFromRecord() {
		// Arrange
		var record = [String: Any]()
		record["Name"] = "Device"
		record["internalName"] = "internalName"
		record["CommunicatorName"] = "communicator"
		record["OnCommand"] = "OnCommand"
		record["OffCommand"] = "OffCommand"
		
		// Act
		let deviceInfo: DeviceInfo?
		do {
			deviceInfo = try DeviceInfo(record: record)
		} catch {
			deviceInfo = nil
			XCTAssert(false)
		}
		
		// Assert
		let name = Name(name: "Device", internalName: "internalName")
		let expectedInfo = DeviceInfo(name: name, communicatorInternalName: "communicator", offCommandInternalName: "OffCommand", onCommandInternalName: "OnCommand")
		
		XCTAssertEqual(deviceInfo, expectedInfo)
	}
	
	func testInit_InitFromRecord_ExpepctsOnInvalidArgumentName() {
		// Arrange
		var record = [String: Any]()
		record["Name"] = "Device"
		record["internalNamee"] = "internalName"
		record["CommunicatorName"] = "communicator"
		record["OnCommand"] = "OnCommand"
		record["OffCommand"] = "OffCommand"
		// Act
		do {
			var deviceInfo = try DeviceInfo(record: record)
			deviceInfo.communicatorInternalName = ""
			// Assert
			
			XCTAssert(false, "Should except")
		} catch {
			XCTAssert(true, "Should except")
		}
		
	}
	
	func testInit_InitFromRecord_ExpecptsOnInvalidDataType() {
		// Arrange
		var record = [String: Any]()
		record["Name"] = 2
		record["internalName"] = "internalName"
		record["CommunicatorName"] = "communicator"
		record["OnCommand"] = "OnCommand"
		record["OffCommand"] = "OffCommand"
		// Act
		do {
			var deviceInfo = try DeviceInfo(record: record)
			deviceInfo.communicatorInternalName = ""
			// Assert
			
			XCTAssert(false, "Should except")
		} catch {
			XCTAssert(true, "Should except")
		}
		
	}
	
	func testEquality_Equals() {
		// Arrange
		let a = DeviceInfo(name: Name(name: "a", internalName: "a"), communicatorInternalName: "a", offCommandInternalName: "a", onCommandInternalName: "a")
		let b = a
		
		//Assert
		XCTAssertEqual(a, b)
	}
	
	func testEquality_Inequal_Name() {
		// Arrange
		let a = DeviceInfo(name: Name(name: "a", internalName: "a"), communicatorInternalName: "a", offCommandInternalName: "a", onCommandInternalName: "a")
		var b = a
		b.name = Name(name: "b", internalName: "b")
		
		//Assert
		XCTAssertNotEqual(a, b)
	}
	
	func testEquality_Inequal_Communicator() {
		// Arrange
		let a = DeviceInfo(name: Name(name: "a", internalName: "a"), communicatorInternalName: "a", offCommandInternalName: "a", onCommandInternalName: "a")
		var b = a
		b.communicatorInternalName = "b"
	
		//Assert
		XCTAssertNotEqual(a, b)
	}
	
	func testEquality_Inequal_OnCommand() {
		// Arrange
		let a = DeviceInfo(name: Name(name: "a", internalName: "a"), communicatorInternalName: "a", offCommandInternalName: "a", onCommandInternalName: "a")
		var b = a
		b.onCommandInternalName = "b"
		
		//Assert
		XCTAssertNotEqual(a, b)
	}
	
	func testEquality_Inequal_OffCommand() {
		// Arrange
		let a = DeviceInfo(name: Name(name: "a", internalName: "a"), communicatorInternalName: "a", offCommandInternalName: "a", onCommandInternalName: "a")
		var b = a
		b.offCommandInternalName = "b"
		
		//Assert
		XCTAssertNotEqual(a, b)
	}


}
