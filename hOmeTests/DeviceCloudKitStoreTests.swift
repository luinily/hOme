//
//  DeviceCloudKitStoreTests.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/02.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class DeviceCloudKitStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	// MARK: Test doubles
	class WrapperSpy: CloudKitWrapperProtocol {
		var fetchRecordsCalled = false
		var argument = ""
		var record = [String: Any]()
		
		func fetchRecordsOfType(type: String, completionHandler: (records: [[String : Any]]) -> Void) {
			fetchRecordsCalled = true
			argument = type

			
			completionHandler(records: [record])
		}
	}
	
	func makeValidRecord() -> [String: Any] {
		var record = [String: Any]()
		record["Name"] = "Device"
		record["internalName"] = "internalName"
		record["CommunicatorName"] = "communicator"
		record["OnCommand"] = "OnCommand"
		record["OffCommand"] = "OffCommand"
		return record
	}
	
	func makeInvalidRecord() -> [String: Any] {
		var record = makeValidRecord()
		record.removeValueForKey("Name")
		return record
	}
	
	// MARK: Tests
	func testFetchDevices_CallsWrapperFetchRecordsOfType() {
		// Arrange
		let spy = WrapperSpy()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.fetchDevices() {
			(devices) in
		}
		
		// Assert
		XCTAssertTrue(spy.fetchRecordsCalled)
	}
	
	func testFetchDevices_CallsWrapperFetchRecordsOfType_WithArgumentDevices() {
		// Arrange
		let spy = WrapperSpy()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.fetchDevices() {
			(devices) in
		}
		
		// Assert
		XCTAssertEqual(spy.argument, "Device")
		
	}
	
	func testFetchDevices_CallsWrapperFetchRecordsOfType_CallsCompletionHandler() {
		// Arrange
		let spy = WrapperSpy()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		var completionHandlerCalled = false
		store.fetchDevices() {
			(devices) in
			completionHandlerCalled = true
		}
		
		// Assert
		XCTAssertTrue(completionHandlerCalled)
		
	}
	
	func testFetchDevices_ConvertRecordsToDeviceInfo_ExpectedResult() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeValidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		// Act
		
		var devices = [DeviceInfo]()
		store.fetchDevices() {
			(records) in
			devices = records
		}
		
		// Assert
		let name = Name(name: "Device", internalName: "internalName")
		let deviceInfo = DeviceInfo(name: name, communicatorInternalName: "communicator", offCommandInternalName: "OffCommand", onCommandInternalName: "OnCommand")
		if let device = devices.first {
			XCTAssertEqual(device, deviceInfo)
		} else {
			XCTAssert(false)
		}
	}
	
	func testFetchDevices_FetchInvalidRecord_NoDeviceReturned() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		// Act
		
		var devices = [DeviceInfo]()
		store.fetchDevices() {
			(records) in
			devices = records
		}
		
		// Assert		
		XCTAssertTrue(devices.isEmpty)
	}

}
