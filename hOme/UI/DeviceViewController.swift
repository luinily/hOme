//
//  DeviceViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import UIKit

class DeviceViewController: UITableViewController {

	@IBOutlet weak var commandTable: UITableView!
	
	private var _device: DeviceProtocol?
	private var _commands = [CommandProtocol]()
	private var _commandToEdit: CommandProtocol?
	private var _selectingOnCommand = true
	
	private let _sectionParameters = 0
	private let _nameRow = 0
	private let _connectorRow = 1
	private let _sectionOnOffCommand = 1
	private let _onCommandRow = 0
	private let _offCommandRow = 1
	
	private let _sectionCommands = 2
	private let _sectionNewCommand = 3
	
	
	
	override func viewDidLoad() {
		if let device = _device {
			navigationItem.title = device.name
		} else {
			navigationItem.title = "Device"
		}
		updateView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateView()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SelectConectorCell,
				view = segue.destinationViewController as? SelectConnectorViewController {
			if let connector = cell.connector {
				view.connectorType = connector.connectorType
				view.selectedConnector = connector
				view.setOnConnectorSelected(getSelectedConnector)
			}
		} else if let cell = sender as? CommandOnOffCell,
				view = segue.destinationViewController as? SelectDeviceCommandViewController {
			view.selectedCommand = cell.command
			_selectingOnCommand = cell.isOnCommand
			view.setDevice(_device, onOffCommandIncluded: false)
			view.setOnCommandSelected(onOnOffCommandSelected)
		} else if let cell = sender as? DeviceCommandCell,
			view = segue.destinationViewController as? IRKitCommandViewController {
			if let command = cell.command as? IRKitCommand {
				view.setCommand(command)
			}
		} else if let view = segue.destinationViewController as? NewIRKitCommandViewController {
			if let device = _device {
				view.setDevice(device)
			}
		}
	}
	
	func setDevice(device: DeviceProtocol) {
		_device = device
		if let application = application {
			setCommands(application.getCommandsOfDevice(deviceInternalName: device.internalName))
		}
	}
	
	func setDevice(internalName: String) {
		if let application = application {
			if let device = application.getDevice(internalName: internalName) {
				setDevice(device: device)
			}
		}
	}

	private func setCommands(_ commands: [CommandProtocol]?) {
		let commands = commands?.filter() {
			includeElement in
			return !(includeElement is OnOffCommand)
		}
		
		if let commands = commands {
			_commands = commands
		}
		
	}
	
	private func showEditCommand(_ command: CommandProtocol) {
		_commandToEdit = command
		if command is IRKitCommand {
			
		}
	}
	
	private func onOnOffCommandSelected(_ command: CommandProtocol) {
		if let command = command as? DeviceCommand {
			if _selectingOnCommand {
				_device?.setOnCommand(command)
			} else {
				_device?.setOffCommand(command)
			}
		}
		commandTable.reloadData()
	}
	
	private func getSelectedConnector(_ connector: Connector) {
		_device?.setConnector(connector)
		updateView()
	}
	
	private func updateView() {
		commandTable.reloadData()
	}
}

//MARK: - ApplicationUser
extension DeviceViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension DeviceViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _sectionParameters:
			return 2
		case _sectionOnOffCommand:
			return 2
		case _sectionCommands:
			if let application = application, device = _device {
				setCommands(application.getCommandsOfDevice(deviceInternalName: device.internalName))
				return _commands.count
			}
			
		case _sectionNewCommand:
			return 1
			
		default:
			return 0
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _sectionParameters:
			return ""
		case _sectionOnOffCommand:
			return "On and Off Commands"
		case _sectionCommands:
			return "Commands"
		case _sectionNewCommand:
			return ""
		default:
			return ""
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		switch (indexPath as NSIndexPath).section {
		case _sectionParameters:
			if (indexPath as NSIndexPath).row == _nameRow {
				cell = makeDeviceNameCell()
			} else if (indexPath as NSIndexPath).row == _connectorRow {
				cell = makeDeviceConnectorCell()
			}
		case _sectionOnOffCommand:
			if (indexPath as NSIndexPath).row == _onCommandRow {
				cell = makeOnCommandCell()
			} else if (indexPath as NSIndexPath).row == _offCommandRow {
				cell = makeOffCommandCell()
			}
		case _sectionCommands:
			cell = makeCommandCell((indexPath as NSIndexPath).row)
		case _sectionNewCommand:
			cell = makeNewCommandCell()
		default:
			cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
		}
		
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: .default, reuseIdentifier: "Cell")
		}
	}
	
	private func makeDeviceNameCell() -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceNameCell")
		if let cell = cell as? NameEditCell {
			cell.nameAble = _device
		}
		return cell
	}
	
	private func makeDeviceConnectorCell() -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceConnectorCell")
		if let cell = cell as? SelectConectorCell {
			cell.connector = _device?.connector
		}
		return cell
	}
	
	private func makeOnCommandCell() -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceOnOffCommandCell")
		if let cell = cell as? CommandOnOffCell {
			cell.command = _device?.onCommand
			cell.isOnCommand = true
		}
		return cell
	}
	
	private func makeOffCommandCell() -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceOnOffCommandCell")
		if let cell = cell as? CommandOnOffCell {
			cell.command = _device?.offCommand
			cell.isOnCommand = false
		}
		return cell
	}
	
	private func makeCommandCell(_ row: Int) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCommandCell")
		if let cell = cell as? DeviceCommandCell {
			cell.command = _commands[row]
		}
		return cell
	}
	
	private func makeNewCommandCell() -> UITableViewCell? {
		return tableView.dequeueReusableCell(withIdentifier: "DeviceAddNewCommandCell")
	}
}

// MARK: Table Delegate
extension DeviceViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? DeviceCommandCell {
			cell.command?.execute()
			cell.isSelected = false
		}
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application {
				application.deleteCommand(self._commands[(indexPath as NSIndexPath).row])
				tableView.reloadData()
			}
		}
		
		let edit = UITableViewRowAction(style: .normal, title: "Edit") {
			action, indexPath in
			self.performSegue(withIdentifier: "IRKitCommandEditSegue", sender: tableView.cellForRow(at: indexPath))
		
		}
		
		return [delete, edit]
	}
	
}
