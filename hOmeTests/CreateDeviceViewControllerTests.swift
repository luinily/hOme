//
//  CreateDeviceViewControllerTests.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import hOme
//@testable import temp

extension UIViewController {
	//this is here to allow the view to be loaded and testable
	func preloadView() {
		let _ = view
	}
}

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
		private var _prepareConnectorInformationHasBeenCalled = false
		
		// MARK: Argument expectations
		//none yet
		
		// MARK: Spied methods
		func prepareConnectorInformation() {
			_prepareConnectorInformationHasBeenCalled = true
		}
	}
	

    func testDisplayConnectorsShouldDisplayConnectorTypesInPicker() {
		// Given
		let connectortypes = ["IRKit", "Imaginary"]
		let connectors = [["A", "B", "C"], ["D", "E"]]
		let viewModel = CreateDevice_GetConnectors_ViewModel(connectorsTypes: connectortypes, connectors: connectors)
		if let viewController = _createDeviceViewController {
			viewController.displayConnectors(viewModel)
			let pickerView = viewController.connectorPicker
			//When
		
			let numberOfComponents = viewController.numberOfComponentsInPickerView(pickerView)
			
			//Then
			XCTAssertEqual(numberOfComponents, 2)
		}
    }
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
