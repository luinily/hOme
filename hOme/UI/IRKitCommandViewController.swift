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
	private let _nameCellIndexPath = IndexPath(row: 0, section: 0)
	private let _commandOnOfftypeCellIndexPath = IndexPath(row: 1, section: 0)
	private let _formatCellIndedxPath = IndexPath(row: 0, section: 1)
	private let _frequenceCellIndexPath = IndexPath(row: 1, section: 1)
	private let _dataCellIndexPath = IndexPath(row: 2, section: 1)
	
	override func viewWillAppear(_ animated: Bool) {
		table.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
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
	
	func setCommand(_ command: IRKitCommand) {
		_command = command
	}
	
	private func isNameValid(_ name: String) -> Bool {
		return !name.isEmpty
	}

}

//MARK: - ApplicationUser
extension IRKitCommandViewController: ApplicationUser {
	
}

//MARK: Table Data Source
extension IRKitCommandViewController {
	
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _nameSection: return ""
		case _infosSection: return "IRKit"
		default: return ""
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _nameSection: return 2
		case _infosSection: return 3
		default: return 0
		}
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	private func makeNameCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCell(withIdentifier: "IRKitNameCell")
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "IRKitCommandOnOffSettingCell")
			if let cell = cell as? IRKitDeviceOnOffSettingCell {
				cell.command = command
			}
			return cell
		}
		return nil
	}
	
	private func makeFormatCell() -> UITableViewCell? {
		if let command = _command {
			let cell = tableView.dequeueReusableCell(withIdentifier: "IRKitDetailCell")
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "IRKitDetailCell")
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "IRKitDataCell")
			if let cell = cell as? IRKitDataCell {
				cell.data = command.irSignal.data
			}
			return cell
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

// MARK: Table Delegate
extension IRKitCommandViewController {
	
}
