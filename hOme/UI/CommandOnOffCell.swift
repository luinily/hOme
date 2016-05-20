//
//  CommandOnOffCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class CommandOnOffCell: UITableViewCell {
	
	@IBOutlet weak var commandTypeLabel: UILabel!
	@IBOutlet weak var commandNameLabel: UILabel!
	private var _command: CommandProtocol? = nil
	private var _isOnCommand: Bool = true
	var command: CommandProtocol? {
		get {return _command}
		set {
			_command = newValue
			commandNameLabel.text = newValue?.name
		}
	}
	
	var isOnCommand: Bool {
		get {return _isOnCommand}
		set {
			_isOnCommand = newValue
			if _isOnCommand {
				commandTypeLabel.text = "OnCommand"
			} else {
				commandTypeLabel.text = "OffCommand"
			}
		}
	}
}
