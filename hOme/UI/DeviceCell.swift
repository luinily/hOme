//
//  DeviceCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class DeviceCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	private var _device: DeviceProtocol?
	var device: DeviceProtocol? {
		get {return _device}
		set {
			_device = newValue
			label.text = newValue?.name
		}
	}
}
