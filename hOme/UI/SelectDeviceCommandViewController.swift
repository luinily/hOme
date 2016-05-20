//
//  SelectDeviceCommandViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectDeviceCommandViewController: UITableViewController {
	@IBOutlet var table: UITableView!
	
	private var _device: DeviceProtocol?
	private var _commands = [CommandProtocol]()
	private var _selectedCommand: CommandProtocol?
	private var _onCommandSelected: ((command: CommandProtocol) -> Void)?
	
	var selectedCommand: CommandProtocol? {
		get {return _selectedCommand}
		set(selectedCommand) {
			_selectedCommand = selectedCommand
		}
	}
	
	override func viewDidLoad() {
		table.delegate = self
		table.dataSource = self
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		if let selectedCommand = _selectedCommand {
			_onCommandSelected?(command: selectedCommand)
		}
	}
	
	func setDevice(device: DeviceProtocol?, onOffCommandIncluded: Bool = true) {
		_device = device
		if let application = application, device = device {
			if let commands = application.getCommandsOfDeviceOfInternalName(device.internalName) {
				if onOffCommandIncluded {
					_commands = commands
				} else {
					_commands = commands.filter() {
						commandIncluded in
						return !(commandIncluded is OnOffCommand)
					}
				}
			}
		}
	}
	
	func setOnCommandSelected(onCommandSelected: (command: CommandProtocol) -> Void) {
		_onCommandSelected = onCommandSelected
	}
}

//MARK: - ApplicationUser
extension SelectDeviceCommandViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension SelectDeviceCommandViewController {
	
	//MARK: Sections
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Commands"
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _commands.count
	}
	
	//MARK: Cells
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell?
			
		cell = tableView.dequeueReusableCellWithIdentifier("DeviceCommandSelectorCell")
		
		if let cell = cell as? SelectDeviceCommandCell {
			cell.command = _commands[indexPath.row]
			cell.commandSelected = cell.command?.name == _selectedCommand?.name
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}

//MARK: - Table Delegate
extension SelectDeviceCommandViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		_selectedCommand = _commands[indexPath.row]
		tableView.reloadData()
	}
}
