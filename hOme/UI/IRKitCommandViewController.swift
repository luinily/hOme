//
//  IRKitCommandViewController.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/02/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitCommandViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	private var _command: IRKitCommand?
	private let _nameSection = 0
	private let _infosSection = 1
	private let _nameCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
	private let _commandOnOfftypeCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
	private let _formatCellIndedxPath = NSIndexPath(forRow: 0, inSection: 1)
	private let _frequenceCellIndexPath = NSIndexPath(forRow: 1, inSection: 1)
	private let _dataCellIndexPath = NSIndexPath(forRow: 2, inSection: 1)
	
	override func viewWillAppear(animated: Bool) {
		table.reloadData()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? IRKitDataCell {
			if let view = segue.destinationViewController as? IRKitDataViewController {
				view.setIRKitData(String(cell.data))
			}
		} else if let cell = sender as? IRKitDeviceOnOffSettingCell {
			if let view = segue.destinationViewController as? CommandOnOffSettingViewController,
				command = cell.command {
				view.setCommand(command)
			}
		}
	}
	
	func setCommand(command: IRKitCommand) {
		_command = command
	}
	
	private func isNameValid(name: String) -> Bool {
		return !name.isEmpty
	}

}

//MARK: - ApplicationUser
extension IRKitCommandViewController: ApplicationUser {
	
}

//MARK: Table Data Source
extension IRKitCommandViewController {
	
	//MARK: Sections
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _nameSection: return ""
		case _infosSection: return "IRKit"
		default: return ""
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _nameSection: return 2
		case _infosSection: return 3
		default: return 0
		}
	}
	
	//MARK: Cells
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		switch indexPath {
		case _nameCellIndexPath:
			cell = makeNameCell()
		case _commandOnOfftypeCellIndexPath:
			cell = makeCommandOnOffTypeCell()
		case _formatCellIndedxPath:
			cell = makeFormatCell()
		case _frequenceCellIndexPath:
			cell = makeFrequenceCell()
		case _dataCellIndexPath:
			cell = makeDataCell()
		default:
			cell = nil
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
	
	private func makeNameCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCellWithIdentifier("IRKitNameCell")
			if let cell = cell as? IRKitNameCell {
				cell.nameableObject = command
				cell.setIsNameValid(isNameValid)
			}
			return cell
		}
		return nil
	}
	
	private func makeCommandOnOffTypeCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCellWithIdentifier("IRKitCommandOnOffSettingCell")
			if let cell = cell as? IRKitDeviceOnOffSettingCell {
				cell.command = command
			}
			return cell
		}
		return nil
	}
	
	private func makeFormatCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCellWithIdentifier("IRKitDetailCell")
			if let label = cell?.textLabel {
				label.text = "Format"
			}
			if let label = cell?.detailTextLabel {
				label.text = command.irSignal.format
			}
			return cell
		}
		return nil
	}
	
	private func makeFrequenceCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCellWithIdentifier("IRKitDetailCell")
			if let label = cell?.textLabel {
				label.text = "Frequence"
			}
			if let label = cell?.detailTextLabel {
				label.text = String(command.irSignal.frequence)
			}
			return cell
		}
		return nil
	}

	private func makeDataCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCellWithIdentifier("IRKitDataCell")
			if let cell = cell as? IRKitDataCell {
				cell.data = command.irSignal.data
			}
			return cell
		}
		return nil
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}

// MARK: Table Delegate
extension IRKitCommandViewController {
	
}
