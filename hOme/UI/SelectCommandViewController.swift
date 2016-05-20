//
//  SelectCommandViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/15.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectCommandViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	private let _deviceSection = 0
	private let _sequenceSection = 1
	private let _removeSection = 2
	
	private var _selectedCommand: CommandProtocol?
	
	private var _onCommandSelected: ((command: CommandProtocol?) -> Void)?
	
	var selectedCommand: CommandProtocol? { return _selectedCommand}
	
	override func viewDidLoad() {
		table.delegate = self
		table.dataSource = self
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? CommandSelectorDeviceCell {
			if let view = segue.destinationViewController as? SelectDeviceCommandViewController {
				if let device = cell.device {
					view.setDevice(device, onOffCommandIncluded: true)
					if let command = _selectedCommand as? DeviceCommand {
						if let commandDevice = command.device {
							if commandDevice == device {
								view.selectedCommand = command
							}
						}
					}
				}
				view.setOnCommandSelected(onCommandSelected)
			}
		}
	}
	
	func setSelectedCommand(selectedCommand: CommandProtocol?) {
		_selectedCommand = selectedCommand
	}
	
	func setOnCommandSelected(onCommandSelected: (command: CommandProtocol?) -> Void) {
		_onCommandSelected = onCommandSelected
	}
	
	private func onCommandSelected(command: CommandProtocol?) {
		_selectedCommand = command
		table.reloadData()
		_onCommandSelected?(command: command)
	}
}

//MARK: - ApplicationUser
extension SelectCommandViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension SelectCommandViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _deviceSection: return "Devices"
		case _sequenceSection: return "Sequences"
		default: return ""
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let application = application {
			switch section {
			case _deviceSection: return application.getDeviceCount()
			case _sequenceSection: return application.getSequenceCount()
			case _removeSection: return 1
			default: return 0
			}
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		if indexPath.section == _deviceSection {
			cell = tableView.dequeueReusableCellWithIdentifier("CommandSelectorDeviceCell")
		} else if indexPath.section == _sequenceSection {
			cell = tableView.dequeueReusableCellWithIdentifier("CommandSelectorSequenceCell")
		} else if indexPath.section == _removeSection {
			cell = tableView.dequeueReusableCellWithIdentifier("CommandSelectorRemoveCell")
		}
		
		if let cell = cell as? CommandSelectorDeviceCell {
			cell.device = application?.getDevices()[indexPath.row]
			cell.selectedCommand = _selectedCommand as? DeviceCommand
			return cell
		} else if let cell = cell as? CommandSelectorSequenceCell {
			cell.sequence = application?.getSequences()[indexPath.row]
			cell.sequenceSelected = cell.sequence?.name == _selectedCommand?.name
			return cell
		} else if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
}

//MARK: - Table Delegate
extension SelectCommandViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == _sequenceSection {
			if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CommandSelectorSequenceCell {
				onCommandSelected(cell.sequence)
			}
		} else if indexPath.section == _removeSection {
			onCommandSelected(nil)
		}
		table.reloadData()
	}
}
