//
//  SequenceViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/10.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequenceViewController: UITableViewController {
	
	@IBOutlet weak var table: UITableView!
	
	private let _sectionProperties = 0
	private let _sectionCommands = 1
	private let _sectionAddCommand = 2
	
	private var _sequence: Sequence?
	private var _commands = [(time: Int, command: CommandProtocol)]()
	
	override func viewDidLoad() {
		table.delegate = self
		table.dataSource = self
		
	}
	
	func setSequence(sequence: Sequence) {
		_sequence = sequence
		makeSequenceArray(sequence)
	}
	
	func makeSequenceArray(sequence: Sequence) {
		let commands = sequence.getCommands()
		var sequenceArray = [(time: Int, command: CommandProtocol)]()
		
		commands.forEach { (time, commands) in
			for command in commands {
				sequenceArray.append((time, command))
			}
		}
		
		_commands = sequenceArray
	}
}

//MARK: - Table Data Source
extension SequenceViewController {
	//MARK: Sections
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _sectionProperties:
			return 1
		case _sectionCommands:
			return _commands.count
		case _sectionAddCommand:
			return 1
		default:
			return 0
		}
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case _sectionProperties:
			return "Name"
		case _sectionCommands:
			return "Commands"
		case _sectionAddCommand:
			return ""
		default:
			return ""
		}
	}
	
	//MARK: Cells
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell?
		
		if indexPath.section == _sectionProperties {
			cell = tableView.dequeueReusableCellWithIdentifier("SequenceNameCell")
			if let cell = cell as? NameEditCell {
				cell.nameAble = _sequence
			}
		} else if indexPath.section == _sectionCommands {
			cell = tableView.dequeueReusableCellWithIdentifier("SequenceCommandCell")
			if let cell = cell as? SequenceCommandCell {
				cell.setCommand(_commands[indexPath.row])
			}
		} else {
			cell = tableView.dequeueReusableCellWithIdentifier("AddSequenceCommandCell")
			if let cell = cell {
				if let label = cell.textLabel {
					label.text = "Add New Command..."
				}
			}
			
		}
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
}


//MARK: - Table Delegate
extension SequenceViewController {
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		if indexPath.section == _sectionCommands {
			let delete = UITableViewRowAction(style: .Destructive, title: "Delete") {
				action, indexPath in
				if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SequenceCommandCell {
					if let sequence = self._sequence, command = cell.command {
						sequence.removeCommand(command.time, commandToRemove: command.command)
						tableView.reloadData()
					}
				}
			}
			
			return [delete]
		} else {
			return []
		}
	}
}
