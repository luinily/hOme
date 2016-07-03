//
//  SelectDeviceCommandCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/05.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectDeviceCommandCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	private var _command: CommandProtocol? = nil
	private var _commandSelected: Bool = false
	
	var command: CommandProtocol? {
		get {return _command}
		set(command) {
			_command = command
			label.text = _command?.name
		}
	}
	
	var commandSelected: Bool {
		get {return _commandSelected}
		set(commandSelected) {
			_commandSelected = commandSelected
			if _commandSelected {
				accessoryType = UITableViewCellAccessoryType.checkmark
			} else {
				accessoryType = UITableViewCellAccessoryType.none
			}
		}
	}
}
