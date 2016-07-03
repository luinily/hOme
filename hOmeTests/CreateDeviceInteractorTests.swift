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
		var validateButtonStateResponse: CreateDevice_ValidateDoneButtonState_Response?
		var hasPresentIfDeviceHasBeenCreatedCalled = false
		var createDeviceResponse: CreateDevice_CreateDevice_Response?
		
		func presentConnectors(_ response: CreateDevice_GetConnectors_Response) {
			hasPresentConnectorsCalled = true
		}
		
		func setDoneButtonState(_ response: CreateDevice_ValidateDoneButtonState_Response) {
			hasSetDoneButtonStateCalled = true
			validateButtonStateResponse = response
		}
		
		func presentCouldCreateDevice(_ response: CreateDevice_CreateDevice_Response) {
			hasPresentIfDeviceHasBeenCreatedCalled = true
			createDeviceResponse = response
		}
	}
	
	class DevicesWorkerSpy: DevicesWorker {
		private var _doCreateDevice: Bool
		var fetchDevicesCalled = false
		var createDeviceCalled = false
		
		init(deviceStore: DeviceStore, doCreateDevice: Bool) {
			_doCreateDevice = doCreateDevice
			super.init(deviceStore: deviceStore)
		}
		
		override func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
			fetchDevicesCalled = true
			completionHandler(devices: [])
		}
		
		override func createDevice(name: String, connectorInternalName: String, completionHandler: (couldCreateDevice: Bool) -> Void) {
			createDeviceCalled = true
			if _doCreateDevice {
				completionHandler(couldCreateDevice: true)
			} else {
				completionHandler(couldCreateDevice: false)
			}
		}
	}
	
	class DeviceStoreSpy: DeviceStore {
		var fetchedDevicesCalled = false
		var createDeviceCalled = false
		
		func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
			fetchedDevicesCalled = true
			let oneSecond = DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
			DispatchQueue.main.after(when: oneSecond) {
				completionHandler(devices: [])
			}
		}
		
		func createDevice(name: String, connectorInternalName: String, completionHandler: (couldCreateDevice: Bool) -> Void) {
			createDeviceCalled = true
			let oneSecond = DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
			DispatchQueue.main.after(when: oneSecond) {
				completionHandler(couldCreateDevice: false)
			}
		}
		
		func deleteDevice(internalName: String, completionHandler: (couldDeleteDevice: Bool) -> Void) {
			
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
		if let response = createDeviceInteractorSpy.validateButtonStateResponse {
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
		if let response = createDeviceInteractorSpy.validateButtonStateResponse {
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
		if let response = createDeviceInteractorSpy.validateButtonStateResponse {
			XCTAssertTrue(response.doneButtonEnabled)
		} else {
			XCTAssert(false)
		}
	}
	
	func testCreateDevice_ShouldCallPresentIfDeviceHasBeenCreated() {
		// Arrange
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let worker = DevicesWorkerSpy(deviceStore: DeviceStoreSpy(), doCreateDevice: false)
		_createDeviceInteractor.devicesWorker = worker
		let request = CreateDevice_CreateDevice_Request(name: "device", connectorInternalName: "deviceInternalName")
		// Act
		_createDeviceInteractor.createDevice(request)
		
		// Assert
		XCTAssertTrue(createDeviceInteractorSpy.hasPresentIfDeviceHasBeenCreatedCalled)
	}
	
	func testCreateDevice_ShouldCallDeviceWorkerCreateDevice() {
		// Arrange
		let spy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = spy
		let worker = DevicesWorkerSpy(deviceStore: DeviceStoreSpy(), doCreateDevice: false)
		_createDeviceInteractor.devicesWorker = worker
		
		let request = CreateDevice_CreateDevice_Request(name: "device", connectorInternalName: "deviceInternalName")
		
		// Act
		_createDeviceInteractor.createDevice(request)
		
		// Assert
		XCTAssertTrue(worker.createDeviceCalled)
	}
	
	func testCreateDevice_ShouldCallPresentIfDeviceHasBeenCreate_trueIfDeviceCreated() {
		// Arrange
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let worker = DevicesWorkerSpy(deviceStore: DeviceStoreSpy(), doCreateDevice: true)
		_createDeviceInteractor.devicesWorker = worker
		let request = CreateDevice_CreateDevice_Request(name: "device", connectorInternalName: "deviceInternalName")
		// Act
		_createDeviceInteractor.createDevice(request)
		
		// Assert
		if let response = createDeviceInteractorSpy.createDeviceResponse {
			XCTAssertTrue(response.couldCreateDevice)
		} else {
			XCTAssert(false)
		}
	}
	
	func testCreateDevice_ShouldCallPresentIfDeviceHasBeenCreate_falseIfDeviceCreated() {
		// Arrange
		let createDeviceInteractorSpy = CreateDeviceInteractorSpy()
		_createDeviceInteractor.output = createDeviceInteractorSpy
		let worker = DevicesWorkerSpy(deviceStore: DeviceStoreSpy(), doCreateDevice: false)
		_createDeviceInteractor.devicesWorker = worker
		let request = CreateDevice_CreateDevice_Request(name: "device", connectorInternalName: "deviceInternalName")
		// Act
		_createDeviceInteractor.createDevice(request)
		
		// Assert
		if let response = createDeviceInteractorSpy.createDeviceResponse {
			XCTAssertFalse(response.couldCreateDevice)
		} else {
			XCTAssert(false)
		}
	}
	
}
