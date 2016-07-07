//
//  NewIRKitCommandViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/27.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NewIRKitCommandViewController: UITableViewController {

	@IBOutlet weak var format: UILabel!
	@IBOutlet weak var frequence: UILabel!
	@IBOutlet weak var data: UILabel!
	@IBOutlet weak var table: UITableView!
	@IBOutlet weak var createButton: UIBarButtonItem!
	@IBOutlet weak var nameTextField: UITextField!
	
	private let _nameSection = 0
	private let _signalSection = 1
	private let _getSignalSection = 2
	private let _getSignalRow = 0
	private let _testCommandRow = 1
	
	private var _command: CommandProtocol?
	private var _device: DeviceProtocol?
	private var _irSignal: IRKITSignal?
	private var _name: String = ""
	private var _onClose: (() -> Void)?
	
	override func viewDidLoad() {
		updateView()
		nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
		nameTextField.becomeFirstResponder()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == _getSignalSection {
			if (indexPath as NSIndexPath).row == _getSignalRow {
				getData()
			} else if (indexPath as NSIndexPath).row == _testCommandRow {
				testCommand()
			}
			tableView.cellForRow(at: indexPath)?.isSelected = false
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _nameSection: return _device?.name
		case _signalSection: return _device?.connector?.name
		case _getSignalSection: return ""
		default: return ""
		}
	}
	
	@IBAction func cancel(_ sender: AnyObject) {
		_onClose?()
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func create(_ sender: AnyObject) {
		createCommand()
		_onClose?()
		self.dismiss(animated: true, completion: nil)
	}
	
	func setDevice(_ device: DeviceProtocol) {
		_device = device
	}
	
	func setOnClose(_ onClose: () -> Void) {
		_onClose = onClose
	}
	
	func textFieldDidChange() {
		if let name = nameTextField.text {
			_name = name
		}
		updateView()
	}
	
	private func getData() {
		if let irKit = _device?.connector as? IRKitConnector {
			irKit.getData() {
				data in
				if data.hasSignal() {
					self._irSignal = data
					self.updateView()
				}
			}
		}
	}
	
	private func testCommand() {
		if let irKit = _device?.connector as? IRKitConnector,
			irSignal = _irSignal {
				if irSignal.hasSignal() {
					irKit.sendDataToIRKit(irSignal) {
						
					}
				}
		}
	}
	
	private func updateView() {
		if let irSignal = _irSignal {
			format.text = irSignal.format
			frequence.text = String(irSignal.frequence)
			data.text = String(irSignal.data)
		} else {
			format.text = "None"
			frequence.text = "None"
			data.text = "None"
		}
		
		createButton.isEnabled = checkInputs()
		
		table.reloadData()
	}
	
	private func checkInputs() -> Bool {
		if let irSignal = _irSignal {
			return (_name != "") && irSignal.hasSignal()
		}
		
		return false
	}
	
	private func createCommand() {
		if let appDelegate = UIApplication.shared().delegate as? AppDelegate,
			device = _device,
			irSignal = _irSignal {
				if let command = appDelegate.homeApplication.createNewCommand(device: device, name: _name) as? IRKitCommand {
					command.setIRSignal(signal: irSignal)
					_command = command
				}
		}
	}
	
}
