//
//  SelectCommandTableDelegate.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/15.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectCommandTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {

	
	private var _device: DeviceProtocol?
	private var _selectedCommand: CommandProtocol?
	private var _showDeviceCommandSelection: ((device: DeviceProtocol) -> Void)?
	private var _onCommandSelected: ((command: CommandProtocol) -> Void)?
	
	var selectedCommand: CommandProtocol? {return _selectedCommand}
		
	func setDevice(device: DeviceProtocol) {
		_device = device
	}
	
	func setSelectedCommand(command: CommandProtocol?) {
		_selectedCommand = command
	}
	
	func setOnCommandSelected(onCommandSelected: (command: CommandProtocol) -> Void) {
		_onCommandSelected = onCommandSelected
	}
	
	func setShowSelectDeviceCommandView(showDevicecommandSelection: (device: DeviceProtocol) -> Void) {
		_showDeviceCommandSelection = showDevicecommandSelection
	}
	
	
	
	func SetTextAccessoryType(cell: UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == _deviceSection {
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
			
			if let command = _selectedCommand as? DeviceCommandProtocol,
				application = getApplication() {
				if command.deviceName == application.getDevices()[indexPath.row].name {
					cell.accessoryType = UITableViewCellAccessoryType.Checkmark
				}
			}
		} else if indexPath.section == _sequenceSection {
			if let application = getApplication() {
				if _selectedCommand?.uniqueName == application.getSequences()[indexPath.row].uniqueName {
					cell.accessoryType = UITableViewCellAccessoryType.Checkmark
				}
			}
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == _deviceSection {
			if let application = getApplication() {
				let device = application.getDevices()[indexPath.row]
				_showDeviceCommandSelection?(device: device)
			}
		} else if indexPath.section == _sequenceSection {
			if let application = getApplication() {
				_selectedCommand = application.getSequences()[indexPath.row]
				tableView.reloadData()
				if let command = _selectedCommand {
					onCommandSelected(command)
				}
			}
		}
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false//indexPath.section == _sectionButtons
	}
	
	private func onCommandSelected(command: CommandProtocol) {
		_onCommandSelected?(command: command)
	}
	
	private func getApplication() -> Application? {
		if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
			return appDelegate.homeApplication
		} else {
			return nil
		}
	}

}
