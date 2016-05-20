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
	
	func setCommand(command: DeviceCommand) {
		_command = command
	}
}

//MARK: Table Data Source
extension CommandOnOffSettingViewController {
	
	//MARK: Sections
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	//MARK: Cells
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CommandOnOffCell")
		
		if let label = cell?.textLabel {
			switch indexPath.row {
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
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
	
	private func setCheckMark(cell: UITableViewCell?, indexPath: NSIndexPath) {
		cell?.accessoryType = .None
		if let command = _command {
			if indexPath.row == command.executionEffectOnDevice.rawValue {
				cell?.accessoryType = .Checkmark
			} else {
				cell?.accessoryType = .None
			}
		}
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}

// MARK: Table Delegate
extension CommandOnOffSettingViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let action = ExecutionEffectOnDevice(rawValue: indexPath.row) {
			_command?.executionEffectOnDevice = action
		}
		table.reloadData()
	}
}
