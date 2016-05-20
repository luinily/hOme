//
//  SequenceCommandViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequenceCommandViewController: UITableViewController {
	@IBOutlet var table: UITableView!

	private let _timeSelectorRow = 0
	private let _commandRow = 1
	private var _time = CommandTime()
	private var _command: CommandProtocol?
	
	private func onTimeChange(newTime: CommandTime) {
		_time = newTime
	}
	
}

//Mark: - Table Data Source
extension SequenceCommandViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		switch indexPath.row {
		case _timeSelectorRow:
			cell = tableView.dequeueReusableCellWithIdentifier("SequenceCommandTimePickerCell")
			if let cell = cell as? SequenceTimeCell {
				cell.time = _time
				cell.onChange = onTimeChange
			}
		case _commandRow:
			cell = tableView.dequeueReusableCellWithIdentifier("SequenceCommandCell")
		default:
			cell = nil
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
}

//Mark: - Table Delegate
extension SequenceCommandViewController {
	
}
