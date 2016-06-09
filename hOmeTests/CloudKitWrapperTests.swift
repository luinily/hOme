//
//  CloudKitWrapperTests.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/02.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
import CloudKit
@testable import hOme

class CloudKitWrapperTests: XCTestCase {
	// MARK: Subject under test
	private var _wrapper: CloudKitWrapper!
}

// MARK: Test lifecycle
extension CloudKitWrapperTests {
	override func setUp() {
		super.setUp()
		_wrapper = CloudKitWrapper()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
}

// MARK: Test setup
extension CloudKitWrapperTests {
	func makeRecord1() -> CKRecord {
		let record = CKRecord(recordType: "Fake")
		record["param1"] = "param1"
		record["param2"] = 2
		return record
	}
	
	func makeRecord2() -> CKRecord {
		let record = CKRecord(recordType: "Fake")
		record["param3"] = "param3"
		record["param4"] = 4
		return record
	}
	
	func makeDeviceDic() -> [String: Any] {
		var dic = [String: Any]()
		dic["Name"] = "name"
		dic["internalName"] = "internalName"
		dic["CommunicatorName"] = "communicatorName"
		dic["OffCommand"] = "offCommand"
		dic["OnCommand"] = "onCommand"
		
		return dic
	}
}

// MARK: Test doubles
extension CloudKitWrapperTests {
	func testConvertRecordToDic_ReturnsDic_ReturnDivWithTwoParam() {
		// Arrange
		let record = makeRecord1()
		// Act
		
		let dic = _wrapper.convertRecordToDic(record)
		
		// Assert
		XCTAssertEqual(dic.count, 2)
		
	}
	
	func testConvertRecordToDic_ReturnsKeys_ReturnsParam1andParam2() {
		// Arrange
		let record = makeRecord1()
		
		// Act
		
		let dic = _wrapper.convertRecordToDic(record)
		let hasKeyParam1 = dic["param1"] != nil
		let hasKeyParam2 = dic["param2"] != nil
		// Assert
		XCTAssertTrue(hasKeyParam1 && hasKeyParam2)
	}
	
	func testConvertRecordToDic_ReturnsValues_ReturnsStringAndInteger() {
		// Arrange
		let record = makeRecord1()
		
		// Act
		let dic = _wrapper.convertRecordToDic(record)
		
		// Assert
		if let param1 = dic["param1"] as? String, param2 = dic["param2"] as? Int {
			let goodParams = (param1 == "param1") && (param2 == 2)
			XCTAssertTrue(goodParams)
		} else {
			XCTAssert(false)
		}
	}
	
	func testConvertRecordsToDic_ReturnsTwoRecords_ReturnsTwoRecords() {
		// Arrange
		let record1 = makeRecord1()
		let record2 = makeRecord2()
		
		// Act
		let dics = _wrapper.convertRecordsToDic([record1, record2])
		
		// Assert
		XCTAssertEqual(dics.count, 2)
	}
	
	func testConvertDicToRecord_nameInRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			if let name = record["Name"] as? String {
				XCTAssertEqual(name, "name")
			} else {
				XCTAssert(false, "does not countains the data")
			}
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	
	func testConvertDicToRecord_internalNameInRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			if let name = record["internalName"] as? String {
				XCTAssertEqual(name, "internalName")
			} else {
				XCTAssert(false, "does not countains the data")
			}
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	func testConvertDicToRecord_CommunicatorNameInRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			if let communicatorName = record["CommunicatorName"] as? String {
				XCTAssertEqual(communicatorName, "communicatorName")
			} else {
				XCTAssert(false, "does not countains the data")
			}
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	func testConvertDicToRecord_OffCommandInRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			if let OffCommand = record["OffCommand"] as? String {
				XCTAssertEqual(OffCommand, "offCommand")
			} else {
				XCTAssert(false, "does not countains the data")
			}
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	func testConvertDicToRecord_OnCommandInRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			if let onCommand = record["OnCommand"] as? String {
				XCTAssertEqual(onCommand, "onCommand")
			} else {
				XCTAssert(false, "does not countains the data")
			}
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	func testConvertDicToRecord_RecordIsOfTypeMyRecord() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
	
			// Assert
			XCTAssertEqual(record.recordType, "myRecord")
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	func testConvertDicToRecord_RecordNameIsInternalName() {
		// Arrange
		let dic = makeDeviceDic()
		
		// Act
		do {
			let record = try _wrapper.convertDicToRecord("myRecord", data: dic)
			
			// Assert
			XCTAssertEqual(record.recordID.recordName, "internalName")
		} catch CloudKitError.CouldNotConvertToCKValueType {
			XCTAssert(false, "could not convert value")
		} catch {
			XCTAssert(false)
		}
	}
	
	
}
