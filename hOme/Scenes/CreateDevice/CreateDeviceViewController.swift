//
//  CreateDeviceViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

//MARK: - CreateDeviceViewControllerInput
protocol CreateDeviceViewControllerInput {
	func displayConnectors(connectorsInfo: CreateDevice_GetConnectors_ViewModel)
	func setDoneButtonState(viewModel: CreateDevice_ValidateDoneButtonState_ViewModel)
}

//MARK: - CreateDeviceViewControllerOutput
protocol CreateDeviceViewControllerOutput {
	func fetchConnectors()
	func validateDoneButtonState(request: CreateDevice_ValidateDoneButtonState_Request)
	func createDevice(request: CreateDevice_CreateDevice_Request)
}



//MARK:- CreateDeviceViewController
class CreateDeviceViewController: UITableViewController {
	var output: CreateDeviceViewControllerOutput!
	var router: CreateDeviceRouter!
	@IBOutlet weak var connectorPicker: UIPickerView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var connectorTextField: UITextField!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	private let _nameCellPath = NSIndexPath(forRow: 0, inSection: 0)
	private let _connectorCellPath = NSIndexPath(forRow: 1, inSection: 0)
	private var _connectorsTypes = [String]()
	private var _connectors: [[CreateDevice_GetConnectors_ViewModel.connectorName]] = []
	
	private var _currentConnectorTypeRow: Int = 0
	private var _selectedConnector: CreateDevice_GetConnectors_ViewModel.connectorName? = nil
	
	// MARK: Object lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		CreateDeviceConfigurator.sharedInstance.configure(self)
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		connectorPicker.dataSource = self
		connectorPicker.delegate = self
		configureConnectorPickerOnLoad()
		validateOkButtonState()
	}
	
	private func configurePicker() {
		connectorTextField.inputView = connectorPicker
	}
	
	// MARK: Event handling

	@IBAction func doneClicked(sender: AnyObject) {
		createDevice()
	}
	
	@IBAction func cancelClicked(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func nameValueChanged(sender: AnyObject) {
		validateOkButtonState()
	}
	
	@IBAction func connectorEditingDidEnd(sender: AnyObject) {
		validateOkButtonState()
	}
	
	private func createDevice() {
		let request = makeCreateDeviceRequest()
		output.createDevice(request)
	}
	
	private func makeCreateDeviceRequest() -> CreateDevice_CreateDevice_Request {
		return CreateDevice_CreateDevice_Request(name: getName(), connectorInternalName: getSelectedConnectorInternalName())
	}
	
	private func getSelectedConnectorInternalName() -> String {
		if let selectedConnector = _selectedConnector {
			return selectedConnector.internalName
		} else {
			return ""
		}
	}
	
	private func configureConnectorPickerOnLoad() {
		// NOTE: Ask the Interactor to do some work
		
		output.fetchConnectors()
		configurePicker()
	}
	
	private func validateOkButtonState() {
		let request = makeValidateDoneButtonStateRequest()
		output.validateDoneButtonState(request)
	}
	
	private func makeValidateDoneButtonStateRequest() -> CreateDevice_ValidateDoneButtonState_Request {
		return CreateDevice_ValidateDoneButtonState_Request(name: getName(), connectorSelected: isConnectorSelected())
	}
	
	private func getName() -> String {
		if let text = nameTextField.text {
			return text
		} else {
			return ""
		}
	}
	
	private func isConnectorSelected() -> Bool {
		if let text = connectorTextField.text {
			return !text.isEmpty
		}
		return false
	}
	// MARK: Display logic
}

//MARK: - UITableViewDelegate
extension CreateDeviceViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath == _nameCellPath {
			nameTextField.becomeFirstResponder()
		} else if indexPath == _connectorCellPath {
			connectorTextField.becomeFirstResponder()
		}
	}
}


//MARK: - PickerView dataSource/delegate
extension CreateDeviceViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 2
	}
 
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0: return _connectorsTypes.count
		case 1: return _connectors[_currentConnectorTypeRow].count
		default: return 0
		}
	}
 
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case 0: return _connectorsTypes[row]
		case 1: return _connectors[_currentConnectorTypeRow][row].name
		default: return "Error"
		}
	}
 
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch component {
		case 0:
			_currentConnectorTypeRow = row
		case 1:
			selectConnector(row)
			
		default:
			return
		}
	}
	
	private func selectConnector(row: Int) {
		_selectedConnector = _connectors[_currentConnectorTypeRow][row]
		connectorTextField.text = _selectedConnector?.name
	}
}

//MARK: - CreateDeviceViewControllerInput
extension CreateDeviceViewController: CreateDeviceViewControllerInput {
	func displayConnectors(connectorsInfo: CreateDevice_GetConnectors_ViewModel) {
		_connectorsTypes = connectorsInfo.connectorsTypes
		_connectors = connectorsInfo.connectors
		//		connectorPicker.reloadAllComponents()
	}
	
	func setDoneButtonState(viewModel: CreateDevice_ValidateDoneButtonState_ViewModel) {
		doneButton.enabled = viewModel.doneButtonEnabled
	}
}
