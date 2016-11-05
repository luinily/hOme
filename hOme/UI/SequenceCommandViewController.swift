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
	
	private func onTimeChange(_ newTime: CommandTime) {
		_time = newTime
	}

	//Mark: - Table Data Source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		switch (indexPath as NSIndexPath).row {
		case _timeSelectorRow:
			cell = tableView.dequeueReusableCell(withIdentifier: "SequenceCommandTimePickerCell")
			if let cell = cell as? SequenceTimeCell {
				cell.time = _time
				cell.onChange = onTimeChange
			}
		case _commandRow:
			cell = tableView.dequeueReusableCell(withIdentifier: "SequenceCommandCell")
		default:
			cell = nil
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
}
