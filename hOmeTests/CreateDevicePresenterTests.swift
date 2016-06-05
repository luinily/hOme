//
//  CreateDevicePresenterTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class CreateDevicePresenterTests: XCTestCase {
	// MARK: Subject under test
	private var _createDevicePresenter: CreateDevicePresenter!
}

// MARK: Test lifecycle
extension CreateDevicePresenterTests {
	override func setUp() {
		super.setUp()
		_createDevicePresenter = CreateDevicePresenter()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
}

// MARK: Test setup
extension CreateDevicePresenterTests {
	
}

// MARK: Test doubles
extension CreateDevicePresenterTests {
	class CreateDevicePresenterOutputMock: CreateDevicePresenterOutput {
		//MARK: Methods call expectations
		private var _hasDisplayConnectorsCalled = false
		private var _hasSetDoneButtonStateCalled = false
		
		//MARK: Arguments expectations
		private var _connectorsInfoViewModel: CreateDevice_GetConnectors_ViewModel?
		private var _doneButtonStateInfoViewModel: CreateDevice_ValidateDoneButtonState_ViewModel?
		
		//MARK: Spied Methods
		func displayConnectors(connectorsInfo: CreateDevice_GetConnectors_ViewModel) {
			_hasDisplayConnectorsCalled = true
			_connectorsInfoViewModel = connectorsInfo
		}
		
		func setDoneButtonState(viewModel: CreateDevice_ValidateDoneButtonState_ViewModel) {
			_hasSetDoneButtonStateCalled = true
			_doneButtonStateInfoViewModel = viewModel
		}
		
		//MARK: Verifications
		func verifyDisplayConnectorsIsCalled() -> Bool {
			return _hasDisplayConnectorsCalled
		}
		
		func verifySetDoneButtonStateIsCalled() -> Bool {
			return _hasSetDoneButtonStateCalled
		}
		
		func verifyDidFormatConnectorTypesAs(expectedTypeStrings: [String]) -> Bool {
			if let resultConnectorTypes = _connectorsInfoViewModel?.connectorsTypes {
				return resultConnectorTypes == expectedTypeStrings
			}
			return false
		}
		
		func verifyCallSetDoneButtonStateWithSameValue(expectedValue: Bool) -> Bool {
			return _doneButtonStateInfoViewModel?.doneButtonEnabled == expectedValue
		}
		
		func verifyDidFormatConnectorsAs(expectedConnectorStrings: [[CreateDevice_GetConnectors_ViewModel.connectorName]]) -> Bool {
			if let resultConnector = _connectorsInfoViewModel?.connectors {
				if resultConnector.count != expectedConnectorStrings.count {
					return false
				}
				for i in 0...resultConnector.count - 1 {
					if resultConnector[i].count != expectedConnectorStrings[i].count {
						return false
					}
					
					for j in 0...resultConnector[i].count - 1 {
						if !resultConnector[i][j].Equal(expectedConnectorStrings[i][j]) {
							return false
						}
					}
					
				}
				return true
			}
			return false
		}
		
	}
	
	class DummyConnector: Connector {
		private var _name = ""
		var name: String {
			get {return _name}
			set {_name = newValue}
		}
		var fullName: String {
			get {return _name}
		}
		
		var internalName: String {
			get {return name + "InternalName"}
		}
		
		var connectorType: ConnectorType {
			get {return .irKit}
		}
		
		func getCommandType() -> CommandType {
			return .irkitCommand
		}
		
		init(name: String) {
			_name = name
		}
	}

}

// MARK: Tests
extension CreateDevicePresenterTests {
	func testPresentConnectors_didConvertTypeToStrings() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock
		
		var connectorsByType = [ConnectorType: [Connector]]()
		connectorsByType[.irKit] = [Connector]()
		
		connectorsByType[.irKit]?.append(DummyConnector(name: "A"))
		connectorsByType[.irKit]?.append(DummyConnector(name: "B"))
		connectorsByType[.irKit]?.append(DummyConnector(name: "C"))
		
		
		let response = CreateDevice_GetConnectors_Response(connectorsTypes: [.irKit], connectorsByType: connectorsByType)
		
		//When
		_createDevicePresenter.presentConnectors(response)
		
		//then
		let expectedTypeStrings = ["IRKit"]
		
		XCTAssertTrue(createDevicePresenterMock.verifyDidFormatConnectorTypesAs(expectedTypeStrings))
	}
	
	func testPresentConnectors_didConvertConnectorsToStrings() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock
		
		var connectorsByType = [ConnectorType: [Connector]]()
		connectorsByType[.irKit] = [Connector]()
		
		connectorsByType[.irKit]?.append(DummyConnector(name: "A"))
		connectorsByType[.irKit]?.append(DummyConnector(name: "B"))
		connectorsByType[.irKit]?.append(DummyConnector(name: "C"))
		
		
		let response = CreateDevice_GetConnectors_Response(connectorsTypes: [.irKit], connectorsByType: connectorsByType)
		
		//When
		_createDevicePresenter.presentConnectors(response)
		
		//then
		let expectedConnectorA = CreateDevice_GetConnectors_ViewModel.connectorName(name: "A", internalName: "AInternalName")
		let expectedConnectorB = CreateDevice_GetConnectors_ViewModel.connectorName(name: "B", internalName: "BInternalName")
		let expectedConnectorC = CreateDevice_GetConnectors_ViewModel.connectorName(name: "C", internalName: "CInternalName")
		let expectedConnectorStrings = [[expectedConnectorA, expectedConnectorB, expectedConnectorC]]
		
		XCTAssertTrue(createDevicePresenterMock.verifyDidFormatConnectorsAs(expectedConnectorStrings))
	}
	
    func testpresentConnectors_didCallDisplayConnectors() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock
		
		var connectorsByType = [ConnectorType: [Connector]]()
		connectorsByType[.irKit] = [Connector]()
		
		let response = CreateDevice_GetConnectors_Response(connectorsTypes: [.irKit], connectorsByType: connectorsByType)
		
		//When
		_createDevicePresenter.presentConnectors(response)
		
		//then
		XCTAssertTrue(createDevicePresenterMock.verifyDisplayConnectorsIsCalled(), "Presenting the connector information should ask view controller to display it")
    }
	
	func testSetDoneButtonState_didCallSetDoneButtonState() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock

		
		let response = CreateDevice_ValidateDoneButtonState_Response(doneButtonEnabled: true)
		
		//When
		_createDevicePresenter.setDoneButtonState(response)
		
		//then
		XCTAssertTrue(createDevicePresenterMock.verifySetDoneButtonStateIsCalled(), "Presenting done button state ask view controller to display it")
	}
	
	func testFunctionName_didCallSetDoneButtonStateWithSameValueTrue() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock
		
		
		let response = CreateDevice_ValidateDoneButtonState_Response(doneButtonEnabled: true)
		
		//When
		_createDevicePresenter.setDoneButtonState(response)
		
		//then
		XCTAssertTrue(createDevicePresenterMock.verifyCallSetDoneButtonStateWithSameValue(true))
	}
	
	func testFunctionName_didCallSetDoneButtonStateWithSameValueFalse() {
		//Given
		let createDevicePresenterMock = CreateDevicePresenterOutputMock()
		_createDevicePresenter.output = createDevicePresenterMock
		
		
		let response = CreateDevice_ValidateDoneButtonState_Response(doneButtonEnabled: false)
		
		//When
		_createDevicePresenter.setDoneButtonState(response)
		
		//then
		XCTAssertTrue(createDevicePresenterMock.verifyCallSetDoneButtonStateWithSameValue(false))
	}
	
}
