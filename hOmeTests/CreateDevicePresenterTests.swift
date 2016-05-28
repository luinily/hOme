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
	
	private var _createDevicePresenter: CreateDevicePresenter!
	
    override func setUp() {
        super.setUp()
		_createDevicePresenter = CreateDevicePresenter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	class CreateDevicePresenterOutputMock: CreateDevicePresenterOutput {
		//MARK: Methods call expectations
		private var _hasDisplayConnectorsCalled = false
		
		//MARK: Arguments expectations
		private var _connectorsInfoViewModel: CreateDevice_GetConnectors_ViewModel?
		
		//MARK: Spied Methods
		func displayConnectors(connectorsInfo: CreateDevice_GetConnectors_ViewModel) {
			_hasDisplayConnectorsCalled = true
			_connectorsInfoViewModel = connectorsInfo
		}
		
		//MARK: Verifications
		func verifyDisplayConnectorsIsCalled() -> Bool {
			return _hasDisplayConnectorsCalled
		}
		
		func verifyDidFormatConnectorTypesAs(expectedTypeStrings: [String]) -> Bool {
			if let resultConnectorTypes = _connectorsInfoViewModel?.connectorsTypes {
				return resultConnectorTypes == expectedTypeStrings
			}
			return false
		}
		
		func verifyDidFormatConnectorsAs(expectedConnectorStrings: [[String]]) -> Bool {
			if let resultConnector = _connectorsInfoViewModel?.connectors {
				return resultConnector == expectedConnectorStrings
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
		let expectedConnectorStrings = [["A", "B", "C"]]
		
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
    
}
