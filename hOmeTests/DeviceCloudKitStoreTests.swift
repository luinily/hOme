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
	// MARK: Subject under test
}

// MARK: Test lifecycle
extension DeviceCloudKitStoreTests {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
}

// MARK: Test setup
extension DeviceCloudKitStoreTests {
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
		record.removeValue(forKey: "Name")
		return record
	}
	
	func makeDefaultRecord(_ name: String, communicatorName: String) -> [String: Any] {
		var record = [String: Any]()
		record["Name"] = name
		record["internalName"] = ""
		record["CommunicatorName"] = communicatorName
		record["OnCommand"] = ""
		record["OffCommand"] = ""
		return record
	}
	
	func AssertDictionaryEqual(_ dictionnary1: [String: Any], dictionnary2: [String: Any]) {
		XCTAssertEqual(dictionnary1.count, dictionnary2.count)
		
		if let name1 = dictionnary1["Name"] as? String,
			let name2 = dictionnary2["Name"] as? String {
			XCTAssertEqual(name1, name2)
		} else {
			XCTAssert(false, "problem with Name")
		}
		
		if dictionnary2["internalName"] == nil {
			XCTAssert(false, "problem with internalName")
		}
		
		if let communicatorName1 = dictionnary1["CommunicatorName"] as? String,
			let communicatorName2 = dictionnary2["CommunicatorName"] as? String {
			XCTAssertEqual(communicatorName1, communicatorName2)
		} else {
			XCTAssert(false, "problem with CommunicatorName")
		}
		
		if let OnCommandName1 = dictionnary1["OnCommand"] as? String,
			let OnCommandName2 = dictionnary2["OnCommand"] as? String {
			XCTAssertEqual(OnCommandName1, OnCommandName2)
		} else {
			XCTAssert(false, "problem with OnCommand")
		}
		
		if let OffCommandName1 = dictionnary1["OffCommand"] as? String,
			let OffCommandName2 = dictionnary2["OffCommand"] as? String {
			XCTAssertEqual(OffCommandName1, OffCommandName2)
		} else {
			XCTAssert(false, "problem with OffCommand")
		}
	}
}

// MARK: Test doubles
extension DeviceCloudKitStoreTests {
	class WrapperSpy: CloudKitWrapperProtocol {
		var fetchRecordsCalled = false
		var createRecordCalled = false
		var deleteDeviceCalled = false
		var type = ""
		var record = [String: Any]()
		
		func fetchRecordsOfType(type: String, completionHandler: (records: [[String : Any]]) -> Void) {
			fetchRecordsCalled = true
			self.type = type
			
			
			completionHandler(records: [record])
		}
		
		func createRecordOfType(type: String, data: [String: Any], conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void) {
			self.type = type
			createRecordCalled = true
			record = data
			conpletionHandler(couldCreateDevice: true, error: nil)
		}
		
		func deleteRecord(recordName: String, completionHandler: (couldDeleteRecord: Bool) -> Void) {
			deleteDeviceCalled = true
		}
	}
}

// MARK: Tests
extension DeviceCloudKitStoreTests {
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
		XCTAssertEqual(spy.type, "Device")
		
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

	func testCreateDevice_ShouldCallCreateRecord() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.createDevice(name: "Device", connectorInternalName: "Connector") {
			(deviceInfo) in
		}
		
		// Assert
		XCTAssertTrue(spy.createRecordCalled)
	}
	
	func testCreateDevice_ShouldCallCreateRecord_typeArgumentShouldBeDevice() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.createDevice(name: "Device", connectorInternalName: "Connector") {
			(deviceInfo) in
		}
		
		// Assert
		XCTAssertEqual(spy.type, "Device")
	}
	
	func testCreateDevice_ShouldCallCreateRecord_dicArgumentShouldBeDeviceRecord() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.createDevice(name: "Device", connectorInternalName: "Connector") {
			(deviceInfo) in
		}
		
		// Assert
		let dic = makeDefaultRecord("Device", communicatorName: "Connector")
		AssertDictionaryEqual(spy.record, dictionnary2: dic)
	}
	
	func testCreateDevice_ShouldCallCreateRecord_completionHandlerPassed() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		var completionHandlerCalled = false
		
		// Act
		store.createDevice(name: "Device", connectorInternalName: "Connector") {
			(deviceInfo) in
			completionHandlerCalled = true
		}
		
		// Assert
		XCTAssertTrue(completionHandlerCalled)
	}
	
	func testDeleteDevice_ShouldCallDeleteDevice() {
		// Arrange
		let spy = WrapperSpy()
		spy.record = makeInvalidRecord()
		let store = DeviceCloudKitStore(cloudKitWrapper: spy)
		
		// Act
		store.deleteDevice(internalName: "Device") {
			(didDeleteDevice) in
		}
		
		// Assert
		XCTAssertTrue(spy.deleteDeviceCalled)
	}
	
}
