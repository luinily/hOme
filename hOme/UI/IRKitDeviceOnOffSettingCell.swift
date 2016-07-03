//
//  IRKitDeviceOnOffSettingCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/09.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitDeviceOnOffSettingCell: UITableViewCell {
	@IBOutlet weak var settingLabel: UILabel!
	private var _command: DeviceCommand?
	
	var command: DeviceCommand? {
		get {return _command}
		set(command) {
			_command = command
			setLabelText()
		}
	}
	
	private func setLabelText() {
		if let command = _command {
			switch command.executionEffectOnDevice {
			case .setDeviceOn:
				settingLabel.text = "On"
			case .setDeviceOff:
				settingLabel.text = "Off"
			case .setDeviceOnOrOff:
				settingLabel.text = "On and Off"
			default:
				settingLabel.text = "None"
			}
		} else {
			settingLabel.text = ""
		}
	}
}
