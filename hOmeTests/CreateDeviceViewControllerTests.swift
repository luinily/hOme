//
//  CreateDeviceViewControllerTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme

class CreateDeviceViewControllerTests: XCTestCase {
	// MARK: Subject under test
	private var _createDeviceViewController: CreateDeviceViewController?
	var window: UIWindow!
}

// MARK: Test lifecycle
extension CreateDeviceViewControllerTests {
    override func setUp() {
        super.setUp()
		window = UIWindow()
		setupCreateOrderViewController()
    }
	
    override func tearDown() {
		window = nil
        super.tearDown()
    }
	
	func loadView() {
		if let viewController = _createDeviceViewController {
			window.addSubview(viewController.view)
			viewController.preloadView()
		}
	}
}

// MARK: Test setup
extension CreateDeviceViewControllerTests {
	private func setupCreateOrderViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		_createDeviceViewController = storyboard.instantiateViewController(withIdentifier: "CreateDeviceViewController") as? CreateDeviceViewController
	}
	
	private func make_IRKit_ABC_Imaginary_DE_viewModel() -> CreateDevice_GetConnectors_ViewModel {
		let connectortypes = ["IRKit", "Imaginary"]
		let connectorA = CreateDevice_GetConnectors_ViewModel.connectorName(name: "A", internalName: "AInternalName")
		let connectorB = CreateDevice_GetConnectors_ViewModel.connectorName(name: "B", internalName: "BInternalName")
		let connectorC = CreateDevice_GetConnectors_ViewModel.connectorName(name: "C", internalName: "CInternalName")
		let connectorD = CreateDevice_GetConnectors_ViewModel.connectorName(name: "D", internalName: "DInternalName")
		let connectorE = CreateDevice_GetConnectors_ViewModel.connectorName(name: "E", internalName: "EInternalName")
		
		let connectors = [[connectorA, connectorB, connectorC], [connectorD, connectorE]]
		
		return CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
		
	}
}

// MARK: Test doubles
extension CreateDeviceViewControllerTests {
	class CreateDeviceViewControllerSpy: CreateDeviceViewControllerOutput {
		//MARK: Methods call expectations
		var fetchConnectorsHasBeenCalled = false
		var validateDoneButtonStateHasBeenCalled = false
		var validateDoneButtonStateRequest: CreateDevice_ValidateDoneButtonState_Request?
		var createDeviceHasBeenCalled = false
		var createDeviceRequest: CreateDevice_CreateDevice_Request?
		//none yet
		
		// MARK: Spied methods
		func fetchConnectors() {
			fetchConnectorsHasBeenCalled = true
		}
		
		func validateDoneButtonState(_ request: CreateDevice_ValidateDoneButtonState_Request) {
			validateDoneButtonStateHasBeenCalled = true
			validateDoneButtonStateRequest = request
		}
		
		func createDevice(_ request: CreateDevice_CreateDevice_Request) {
			createDeviceHasBeenCalled = true
			createDeviceRequest = request
		}
	}
}

// MARK: Tests
extension CreateDeviceViewControllerTests {
    func testShouldHave2ConnectorTypesInPicker() {
		if let viewController = _createDeviceViewController {
			// Given
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
		
			let numberOfComponents = viewController.numberOfComponents(in: pickerView)
			
			//Then
			XCTAssertEqual(numberOfComponents, 2)
		} else {
			XCTAssert(false, "viewController not created")
		}
    }
	
	func testPickerShouldHave2RowsIn1stComponent() {
		if let viewController = _createDeviceViewController {
			// Given
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
			
			let numberOfConnectors = viewController.pickerView(pickerView, numberOfRowsInComponent: 0)
			
			//Then
			XCTAssertEqual(numberOfConnectors, 2)
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testPickerShouldHave3RowsIn2ndComponent() {
		if let viewController = _createDeviceViewController {
			// Given
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
			
			let numberOfConnectors = viewController.pickerView(pickerView, numberOfRowsInComponent: 1)
			
			//Then
			XCTAssertEqual(numberOfConnectors, 3)
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testPicker1stComponentName() {
		if let viewController = _createDeviceViewController {
			// Given
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
			
			var titles = [String]()
			for i in 0...1 {
				if let title = viewController.pickerView(pickerView, titleForRow: i, forComponent: 0) {
					titles.append(title)
				}
			}
			
			//Then
			XCTAssertEqual(titles, ["IRKit", "Imaginary"])
		} else {
			XCTAssert(false, "viewController not created")
		}
	}

	func testPicker2ndComponentName() {
		if let viewController = _createDeviceViewController {
			// Given
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
			
			var titles = [String]()
			for i in 0...2 {
				if let title = viewController.pickerView(pickerView, titleForRow: i, forComponent: 1) {
					titles.append(title)
				}
			}
			
			//Then
			XCTAssertEqual(titles, ["A", "B", "C"])
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testPickerSelectedConnector() {
		if let viewController = _createDeviceViewController {
			// Given
			viewController.preloadView()
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			//When
			
			viewController.pickerView(pickerView, didSelectRow: 0, inComponent: 1)
			
			//Then
			if let title = viewController.connectorTextField.text {
				XCTAssertEqual(title, "A")
			} else {
				XCTAssert(false, "no text field in connectorTextField")
			}
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testViewControllerConfiguredwhenViewIsLoaded() {
		if let viewController = _createDeviceViewController {
			viewController.preloadView()
			XCTAssertEqual(viewController.connectorTextField.inputView, viewController.connectorPicker)
		}
		
	}
	
	func testViewDidLoad_ShouldAskForDoneButtonState() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			
			// When
			loadView()
			
			// Then
			XCTAssertTrue(createDeviceViewControllerOutputSpy.validateDoneButtonStateHasBeenCalled, "Should ask for the button state")
		}
	}
	
	func testViewDidLoad_AskButtonStateRecord_EmptyNameAndNoConnector() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			
			// When
			loadView()
			
			// Then
			
			XCTAssertEqual(createDeviceViewControllerOutputSpy.validateDoneButtonStateRequest?.name, "")
			XCTAssertEqual(createDeviceViewControllerOutputSpy.validateDoneButtonStateRequest?.connectorSelected, false)
		}
	}
	
	func testnameValueChanged_shouldAskForButtonState_nameIsTextFieldText() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			viewController.preloadView()
			viewController.nameTextField.text = "device_name"
			// When
			viewController.nameValueChanged(viewController.nameTextField)
			
			// Then
			
			XCTAssertEqual(createDeviceViewControllerOutputSpy.validateDoneButtonStateRequest?.name, "device_name")
		}
	}
	
	func testconnectorEditingDidEnd_shouldAskForButtonState_connectorIsTrue() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			viewController.preloadView()
			viewController.connectorTextField.text = "connector"
			
			// When
			viewController.connectorEditingDidEnd(viewController.connectorTextField)
			
			// Then
			XCTAssertEqual(createDeviceViewControllerOutputSpy.validateDoneButtonStateRequest?.connectorSelected, true)
		}
	}
	
	func testSetDoneButtonState_SetDoneButtonSet_ToEnabled() {
		if let viewController = _createDeviceViewController {
			// Given
			viewController.preloadView()
			let viewModel = CreateDevice_ValidateDoneButtonState_ViewModel(doneButtonEnabled: true)
			
			// When
			viewController.setDoneButtonState(viewModel)
			
			// Then
			XCTAssertTrue(viewController.doneButton.isEnabled)
		}
	}
	
	func testSetDoneButtonState_SetDoneButtonSet_ToNotEnabled() {
		if let viewController = _createDeviceViewController {
			// Given
			viewController.preloadView()
			let viewModel = CreateDevice_ValidateDoneButtonState_ViewModel(doneButtonEnabled: false)
			
			// When
			viewController.setDoneButtonState(viewModel)
			
			// Then
			XCTAssertFalse(viewController.doneButton.isEnabled)
		}
	}
	
	func testDoneClicked_SendCreateDeviceRequest_RequestSentToInterractor() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			viewController.preloadView()
			viewController.nameTextField.text = "device"
			viewController.connectorTextField.text = "connector"
			
			// When
			viewController.doneClicked(viewController.doneButton)
			
			// Then
			XCTAssertTrue(createDeviceViewControllerOutputSpy.createDeviceHasBeenCalled)
		}
	}
	
	func testDoneClicked_SendCreateDeviceRequest_nameIsTextFieldText() {
		if let viewController = _createDeviceViewController {
			// Given
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			viewController.preloadView()
			viewController.nameTextField.text = "device_name"
			
			// When
			viewController.doneClicked(viewController.doneButton)
			
			// Then
			
			XCTAssertEqual(createDeviceViewControllerOutputSpy.createDeviceRequest?.name, "device_name")
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testconnectorEditingDidEnd_shouldAskForButtonState_connectorInternalNameIsOk() {
		if let viewController = _createDeviceViewController {
			// Given
			viewController.preloadView()
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy
			
			let viewModel = make_IRKit_ABC_Imaginary_DE_viewModel()
			viewController.displayConnectors(viewModel)
			guard let pickerView = viewController.connectorPicker else {
				XCTAssert(false, "no picker view")
				return
			}
			viewController.pickerView(pickerView, didSelectRow: 0, inComponent: 1)
			
			//When
			viewController.doneClicked(viewController.doneButton)
			
			
			//Then
			XCTAssertEqual(createDeviceViewControllerOutputSpy.createDeviceRequest?.connectorInternalName, "AInternalName")
		} else {
			XCTAssert(false, "viewController not created")
		}
	}
	
	func testconnectorEditingDidEnd_shouldAskForButtonState_connectorInternalNameEmpty() {
		if let viewController = _createDeviceViewController {
			// Arrange
			viewController.preloadView()
			let createDeviceViewControllerOutputSpy = CreateDeviceViewControllerSpy()
			viewController.output = createDeviceViewControllerOutputSpy

			
			// Act
			viewController.doneClicked(viewController.doneButton)
			
			
			// Assert
			if let request = createDeviceViewControllerOutputSpy.createDeviceRequest {
				XCTAssertTrue(request.connectorInternalName.isEmpty)
				return
			}
		}
		XCTAssert(false)
		
	}
}
