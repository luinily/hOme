//
//  DeviceCommandCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class DeviceCommandCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	private var _command: CommandProtocol? = nil
	var command: CommandProtocol? {
		get {return _command}
		set {
			_command = newValue
			label.text = newValue?.name
		}
	}
}
