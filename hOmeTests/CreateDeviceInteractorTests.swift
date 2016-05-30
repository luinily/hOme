//
//  CreateDeviceInteractorTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class CreateDeviceInteractorTests: XCTestCase {
	
	private var _createDeviceInteractor: CreateDeviceInteractor!
	
    override func setUp() {
        super.setUp()
		
		_createDeviceInteractor = CreateDeviceInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	class CreateDeviceInteractorSpy: CreateDeviceInteractorOutput {
		var hasPresentConnectorsCalled = false
		
		func presentConnectors(response: CreateDevice_GetConnectors_Response) {
			hasPresentConnectorsCalled = true
		}
		
	}
	
	func testPrepareConnectorInformation_didCallPresentConnectors() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		
		//When
		_createDeviceInteractor.prepareConnectorInformation()
		
		//then
		XCTAssertTrue(createDeviceInteractorSpy.hasPresentConnectorsCalled, "Preparing the connector information should ask presenter to format it")
	}
    
}
