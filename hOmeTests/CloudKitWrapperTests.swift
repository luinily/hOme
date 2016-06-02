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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testConvertRecordToDic_ReturnsDic_ReturnDivWithTwoParam() {
		// Arrange
		let wrapper = CloudKitWrapper()
		let record = CKRecord(recordType: "Fake")
		record["param1"] = "param1"
		record["param2"] = 2
		// Act
		
		let dic = wrapper.convertRecordToDic(record)
		
		// Assert
		XCTAssertEqual(dic.count, 2)
		
	}
	
	func testConvertRecordToDic_ReturnsKeys_ReturnsParam1andParam2() {
		// Arrange
		let wrapper = CloudKitWrapper()
		let record = CKRecord(recordType: "Fake")
		record["param1"] = "param1"
		record["param2"] = 2
		// Act
		
		let dic = wrapper.convertRecordToDic(record)
		let hasKeyParam1 = dic["param1"] != nil
		let hasKeyParam2 = dic["param2"] != nil
		// Assert
		XCTAssertTrue(hasKeyParam1 && hasKeyParam2)
	}
	
	func testConvertRecordToDic_ReturnsValues_ReturnsStringAndInteger() {
		// Arrange
		let wrapper = CloudKitWrapper()
		let record = CKRecord(recordType: "Fake")
		record["param1"] = "param1"
		record["param2"] = 2
		
		// Act
		let dic = wrapper.convertRecordToDic(record)
		
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
		let wrapper = CloudKitWrapper()
		let record1 = CKRecord(recordType: "Fake")
		record1["param1"] = "param1"
		record1["param2"] = 2
		let record2 = CKRecord(recordType: "Fake")
		record2["param3"] = "param3"
		record2["param4"] = 4
		
		// Act
		let dics = wrapper.convertRecordsToDic([record1, record2])
		
		// Assert
		XCTAssertEqual(dics.count, 2)
	}
	
}
