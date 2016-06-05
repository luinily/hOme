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
	// MARK: Subject under test
	private var _createDeviceInteractor: CreateDeviceInteractor!
}

// MARK: Test lifecycle
extension CreateDeviceInteractorTests {
	override func setUp() {
		super.setUp()
		
		_createDeviceInteractor = CreateDeviceInteractor()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
}

// MARK: Test setup
extension CreateDeviceInteractorTests {
	
}

// MARK: Test doubles
extension CreateDeviceInteractorTests {
	class CreateDeviceInteractorSpy: CreateDeviceInteractorOutput {
		var hasPresentConnectorsCalled = false
		var hasSetDoneButtonStateCalled = false
		var response: CreateDevice_ValidateDoneButtonState_Response?
		
		func presentConnectors(response: CreateDevice_GetConnectors_Response) {
			hasPresentConnectorsCalled = true
		}
		
		func setDoneButtonState(response: CreateDevice_ValidateDoneButtonState_Response) {
			hasSetDoneButtonStateCalled = true
			self.response = response
		}
		
	}
}

// MARK: Tests
extension CreateDeviceInteractorTests {
	func testPrepareConnectorInformation_didCallPresentConnectors() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		
		//When
		_createDeviceInteractor.fetchConnectors()
		
		//then
		XCTAssertTrue(createDeviceInteractorSpy.hasPresentConnectorsCalled, "Preparing the connector information should ask presenter to format it")
	}
	
	func testvalidateDoneButtonState_didCallUpdateDoneButtonState() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let request = CreateDevice_ValidateDoneButtonState_Request(name: "name", connectorSelected: true)
		//When
		_createDeviceInteractor.validateDoneButtonState(request)
		
		//then
		XCTAssertTrue(createDeviceInteractorSpy.hasSetDoneButtonStateCalled, "validating the done button state should ask the presenter to set it")
	}
	
	func testValidateDoneButtonState_responseWhenNameIsEmty_shouldBeFalse() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let request = CreateDevice_ValidateDoneButtonState_Request(name: "", connectorSelected: true)
		//When
		_createDeviceInteractor.validateDoneButtonState(request)
		
		//then
		if let response = createDeviceInteractorSpy.response {
			XCTAssertFalse(response.doneButtonEnabled)
		} else {
			XCTAssert(false)
		}
	}
	
	func testValidateDoneButtonState_responseWhenConnectorIsNotSelected_shouldBeFalse() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let request = CreateDevice_ValidateDoneButtonState_Request(name: "name", connectorSelected: false)
		//When
		_createDeviceInteractor.validateDoneButtonState(request)
		
		//then
		if let response = createDeviceInteractorSpy.response {
			XCTAssertFalse(response.doneButtonEnabled)
		} else {
			XCTAssert(false)
		}
	}
	
	func testValidateDoneButtonState_responseWhenNameAndConnectorOk_shouldBeTrue() {
		//Given
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let request = CreateDevice_ValidateDoneButtonState_Request(name: "name", connectorSelected: true)
		//When
		_createDeviceInteractor.validateDoneButtonState(request)
		
		//then
		if let response = createDeviceInteractorSpy.response {
			XCTAssertTrue(response.doneButtonEnabled)
		} else {
			XCTAssert(false)
		}
	}
	
}
