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
	private var _command: IRKitCommand?
	
	private let _numberOfSections = 2
	//Mark: Name Section Constants
	private let _nameSection = 0
	private let _numberOfCellsInNameSection = 2
	private let _nameCellIndexPath = IndexPath(row: 0, section: 0)
	private let _commandOnOfftypeCellIndexPath = IndexPath(row: 1, section: 0)
	
	//Mark: info Section Constants
	private let _infosSection = 1
	private let _numberOfCellsInInfoSection = 4
	private let _formatCellIndexPath = IndexPath(row: 0, section: 1)
	private let _frequenceCellIndexPath = IndexPath(row: 1, section: 1)
	private let _dataCellIndexPath = IndexPath(row: 2, section: 1)
	private let _dataReloadCellIndexPath = IndexPath(row: 3, section: 1)
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
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
		return _numberOfSections
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
		case _nameSection: return _numberOfCellsInNameSection
		case _infosSection: return _numberOfCellsInInfoSection
		default: return 0
		}
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = makeCellForIndexPath(indexPath: indexPath) {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	private func makeCellForIndexPath(indexPath: IndexPath) -> UITableViewCell? {
		switch indexPath {
		case _nameCellIndexPath:
			return makeNameCell()
		case _commandOnOfftypeCellIndexPath:
			return makeCommandOnOffTypeCell()
		case _formatCellIndexPath:
			return makeFormatCell()
		case _frequenceCellIndexPath:
			return makeFrequenceCell()
		case _dataCellIndexPath:
			return makeDataCell()
		case _dataReloadCellIndexPath:
			return makeReloadDataCell()
		default:
			return nil
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
	
	private func makeReloadDataCell() -> UITableViewCell? {
		return tableView.dequeueReusableCell(withIdentifier: "IRKitGetDataCell")
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

// MARK: Table Delegate
extension IRKitCommandViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == _dataReloadCellIndexPath {
			reloadCommandData()
		}
	}
	
	private func reloadCommandData() {
		if let command = _command {
			command.reloadIRSignal() {
				self.tableView.reloadData()
			}
		}
	}
}
