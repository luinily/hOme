//
//  NewDeviceNameCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/29.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NewDeviceNameCell: UITableViewCell {
	
	@IBOutlet weak var textEdit: UITextField!
	
	private var _name: String = "New Device"
	private var _onNameChanged: ((newName: String) -> Void)?
	
	var name: String {
		get {return _name}
		set {
			_name = newValue
			textEdit.text = newValue
		}
	}
	
	var onNameChanged: ((newName: String) -> Void)? {
		get {return _onNameChanged}
		set {
			_onNameChanged = newValue
		}
	}
	
	@IBAction func onValueChanged(sender: AnyObject) {
		if let newName = textEdit.text {
			_name = newName
			_onNameChanged?(newName: newName)
		}
	}
	
	
}
