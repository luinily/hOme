//
//  SelectDeviceCommandViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectDeviceCommandViewController: UITableViewController, ApplicationUser {
	@IBOutlet var table: UITableView!
	
	private var _device: DeviceProtocol?
	private var _commands = [CommandProtocol]()
	private var _selectedCommand: CommandProtocol?
	private var _onCommandSelected: ((_ command: CommandProtocol) -> Void)?
	
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
	
	override func willMove(toParentViewController parent: UIViewController?) {
		if let selectedCommand = _selectedCommand {
			_onCommandSelected?(selectedCommand)
		}
	}
	
	func setDevice(_ device: DeviceProtocol?, onOffCommandIncluded: Bool = true) {
		_device = device
		if let application = application, let device = device {
			if let commands = application.getCommandsOfDevice(deviceInternalName: device.internalName) {
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
	
	func setOnCommandSelected(_ onCommandSelected: @escaping (_ command: CommandProtocol) -> Void) {
		_onCommandSelected = onCommandSelected
	}

	//MARK: - Table Data Source
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Commands"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _commands.count
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell?
			
		cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCommandSelectorCell")
		
		if let cell = cell as? SelectDeviceCommandCell {
			cell.command = _commands[(indexPath as NSIndexPath).row]
			cell.commandSelected = cell.command?.name == _selectedCommand?.name
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false
	}

	//MARK: - Table Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		_selectedCommand = _commands[(indexPath as NSIndexPath).row]
		tableView.reloadData()
	}
}
