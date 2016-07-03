//
//  CommandSelectorDeviceCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/05.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class CommandSelectorDeviceCell: UITableViewCell {
	@IBOutlet weak var deviceLabel: UILabel!
	@IBOutlet weak var commandLabel: UILabel!
	
	private var _device: DeviceProtocol? = nil
	private var _selectedCommand: DeviceCommand? = nil
	
	var device: DeviceProtocol? {
		get {return _device}
		set(device) {
			_device = device
			deviceLabel.text = device?.name
			commandLabel.text = ""
		}
	}
	
	var selectedCommand: DeviceCommand? {
		get {return _selectedCommand}
		set(selectedCommand) {
			if selectedCommand?.deviceInternalName == device?.internalName {
				_selectedCommand = selectedCommand
				commandLabel.text = selectedCommand?.name
				accessoryType = UITableViewCellAccessoryType.checkmark
			} else {
				_selectedCommand = nil
				accessoryType = UITableViewCellAccessoryType.disclosureIndicator
			}
		}
	}
}
