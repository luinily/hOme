//
//  IRKitNameCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitNameCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!
	private var _nameableObject: Nameable?
	private var _isNameValid: ((name: String) -> Bool)?
	
	

	var nameableObject: Nameable? {
		get {return _nameableObject}
		set(nameableObject) {
			_nameableObject = nameableObject
			textField.text = nameableObject?.name
			textField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingDidEnd)
			textField.addTarget(self, action: #selector(textFieldContentChanged), forControlEvents: .EditingChanged)
			
		}
	}
	
	func setIsNameValid(isNameValid: (name: String) -> Bool) {
		_isNameValid = isNameValid
	}
	
	func textFieldDidChange() {
		if let name = textField.text {
			_nameableObject?.name = name
		}
	}
	
	func textFieldContentChanged() {
		if let newName = textField.text {
			if isNameValid(newName) {
				textField.textColor = UIColor.blackColor()
			} else {
				textField.textColor = UIColor.redColor()
			}
		}
	}
	
	private func isNameValid(name: String) -> Bool {
		if let isNameValid = _isNameValid {
			if isNameValid(name: name) {
				return true
			} else {
				return false
			}
		} else {
			return true
		}
	}
}
