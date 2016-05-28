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
	
	private var _createDeviceViewController: CreateDeviceViewController?
	
    override func setUp() {
        super.setUp()
		
		setupCreateOrderViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func setupCreateOrderViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		_createDeviceViewController = storyboard.instantiateViewControllerWithIdentifier("CreateDeviceViewController") as? CreateDeviceViewController
		_createDeviceViewController?.preloadView()
	}
	
	class CreateDeviceViewControllerSpy: CreateDeviceViewControllerOutput {
		//MARK: Methods call expectations
		var prepareConnectorInformationHasBeenCalled = false
		//none yet
		
		// MARK: Spied methods
		func prepareConnectorInformation() {
			prepareConnectorInformationHasBeenCalled = true
		}
	}
	

    func testShouldHave2ConnectorTypesInPicker() {
		if let viewController = _createDeviceViewController {
			// Given
			let connectortypes = ["IRKit", "Imaginary"]
			let connectors = [["A", "B", "C"], ["D", "E"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
			//When
		
			let numberOfComponents = viewController.numberOfComponentsInPickerView(pickerView)
			
			//Then
			XCTAssertEqual(numberOfComponents, 2)
		} else {
			XCTAssert(false, "viewController not created")
		}
    }
	
	func testPickerShouldHave2RowsIn1stComponent() {
		if let viewController = _createDeviceViewController {
			// Given
			let connectortypes = ["IRKit", "Imaginary"]
			let connectors = [["A", "B", "C"], ["D", "E"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
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
			let connectortypes = ["IRKit", "Imaginary"]
			let connectors = [["A", "B", "C"], ["D", "E"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
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
			let connectortypes = ["IRKit", "Imaginary"]
			let connectors = [["A", "B", "C"], ["D", "E"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
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
			let connectortypes = ["IRKit"]
			let connectors = [["A", "B", "C"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
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
			let connectortypes = ["IRKit", "Imaginary"]
			let connectors = [["A", "B", "C"], ["D", "E"]]
			let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
			
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
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
			XCTAssertEqual(viewController.connectorTextField.inputView, viewController.connectorPicker)
		}
		
	}
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
