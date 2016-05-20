//
//  SequenceCommandCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/04.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequenceCommandCell: UITableViewCell {
	private var _command: (time: Int, command: CommandProtocol)?
	
	var command: (time: Int, command: CommandProtocol)? {return _command}
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	func setCommand(command: (time: Int, command: CommandProtocol)) {
		_command = command
		timeLabel.text = String(command.time) + " m"
		detailLabel.text = command.command.fullName
	}
}
