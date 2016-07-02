//
//  DeviceCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/07/02.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class DeviceCell: UITableViewCell {
	private var _device: DisplayDevice?
	var device: DisplayDevice? {
		get {return _device}
		set {
			_device = newValue
			nameLabel.text = _device?.name
		}
	}
	
	@IBOutlet weak var nameLabel: UILabel!
}
