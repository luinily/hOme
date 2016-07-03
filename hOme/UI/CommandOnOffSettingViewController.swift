//
//  CommandOnOffSettingViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/09.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class CommandOnOffSettingViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	private var _command: DeviceCommand? = nil
	
	func setCommand(_ command: DeviceCommand) {
		_command = command
	}
}

//MARK: Table Data Source
extension CommandOnOffSettingViewController {
	
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CommandOnOffCell")
		
		if let label = cell?.textLabel {
			switch (indexPath as NSIndexPath).row {
			case 0: label.text = "None"
			case 1: label.text = "On"
			case 2: label.text = "Off"
			case 3: label.text = "On and Off"
			default: label.text = ""
			}
		}
		
		setCheckMark(cell, indexPath: indexPath)
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	private func setCheckMark(_ cell: UITableViewCell?, indexPath: IndexPath) {
		cell?.accessoryType = .none
		if let command = _command {
			if (indexPath as NSIndexPath).row == command.executionEffectOnDevice.rawValue {
				cell?.accessoryType = .checkmark
			} else {
				cell?.accessoryType = .none
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

// MARK: Table Delegate
extension CommandOnOffSettingViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let action = ExecutionEffectOnDevice(rawValue: (indexPath as NSIndexPath).row) {
			_command?.executionEffectOnDevice = action
		}
		table.reloadData()
	}
}
