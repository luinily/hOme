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
	
	func setSequence(_ sequence: Sequence) {
		_sequence = sequence
		makeSequenceArray(sequence)
	}
	
	func makeSequenceArray(_ sequence: Sequence) {
		let commands = sequence.getCommands()
		var sequenceArray = [(time: Int, command: CommandProtocol)]()
		
		commands.forEach { (time, commands) in
			for command in commands {
				sequenceArray.append((time, command))
			}
		}
		
		_commands = sequenceArray
	}

	//MARK: - Table Data Source
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell?
		
		if (indexPath as NSIndexPath).section == _sectionProperties {
			cell = tableView.dequeueReusableCell(withIdentifier: "SequenceNameCell")
			if let cell = cell as? NameEditCell {
				cell.nameAble = _sequence
			}
		} else if (indexPath as NSIndexPath).section == _sectionCommands {
			cell = tableView.dequeueReusableCell(withIdentifier: "SequenceCommandCell")
			if let cell = cell as? SequenceCommandCell {
				cell.setCommand(_commands[(indexPath as NSIndexPath).row])
			}
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "AddSequenceCommandCell")
			if let cell = cell {
				if let label = cell.textLabel {
					label.text = "Add New Command..."
				}
			}
			
		}
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}

	//MARK: - Table Delegate
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		if (indexPath as NSIndexPath).section == _sectionCommands {
			let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
				action, indexPath in
				if let cell = tableView.cellForRow(at: indexPath) as? SequenceCommandCell {
					if let sequence = self._sequence, let command = cell.command {
						sequence.removeCommand(time: command.time, commandToRemove: command.command)
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
