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
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
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
	
	func setSelectedCommand(_ selectedCommand: CommandProtocol?) {
		_selectedCommand = selectedCommand
	}
	
	func setOnCommandSelected(_ onCommandSelected: (command: CommandProtocol?) -> Void) {
		_onCommandSelected = onCommandSelected
	}
	
	private func onCommandSelected(_ command: CommandProtocol?) {
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
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _deviceSection: return "Devices"
		case _sequenceSection: return "Sequences"
		default: return ""
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		if (indexPath as NSIndexPath).section == _deviceSection {
			cell = tableView.dequeueReusableCell(withIdentifier: "CommandSelectorDeviceCell")
		} else if (indexPath as NSIndexPath).section == _sequenceSection {
			cell = tableView.dequeueReusableCell(withIdentifier: "CommandSelectorSequenceCell")
		} else if (indexPath as NSIndexPath).section == _removeSection {
			cell = tableView.dequeueReusableCell(withIdentifier: "CommandSelectorRemoveCell")
		}
		
		if let cell = cell as? CommandSelectorDeviceCell {
			cell.device = application?.getDevices()[(indexPath as NSIndexPath).row]
			cell.selectedCommand = _selectedCommand as? DeviceCommand
			return cell
		} else if let cell = cell as? CommandSelectorSequenceCell {
			cell.sequence = application?.getSequences()[(indexPath as NSIndexPath).row]
			cell.sequenceSelected = cell.sequence?.name == _selectedCommand?.name
			return cell
		} else if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
}

//MARK: - Table Delegate
extension SelectCommandViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == _sequenceSection {
			if let cell = tableView.cellForRow(at: indexPath) as? CommandSelectorSequenceCell {
				onCommandSelected(cell.sequence)
			}
		} else if (indexPath as NSIndexPath).section == _removeSection {
			onCommandSelected(nil)
		}
		table.reloadData()
	}
}
