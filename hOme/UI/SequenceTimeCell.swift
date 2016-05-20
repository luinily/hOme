//
//  SequenceTimeCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequenceTimeCell: UITableViewCell {
	private var _timeEditor: UITextField!
	@IBOutlet weak var timeEditor: UITextField! {
		get {return _timeEditor}
		set {
			_timeEditor = newValue
			_timeEditor.delegate = self
		}
	}

	@IBAction func editingDidEnd(sender: AnyObject) {
		if let newTime = _timeEditor.text {
			_time?.time = newTime
			if let time = _time {
				_onChange?(newValue: time)
			}
		}
	}
	
	private var _time: CommandTime?
	var time: CommandTime? {
		get {return _time}
		set {
			_time = newValue
			_timeEditor.text = newValue?.time
		}
	}
	
	private var _onChange: ((newValue: CommandTime) -> Void)?
	var onChange: ((newValue: CommandTime) -> Void)? {
		get {return _onChange}
		set {
			_onChange = newValue
		}
	}
}

extension SequenceTimeCell: UITextFieldDelegate {
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		guard let stringCharacterRange = string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) else {
			return false
		}
		if stringCharacterRange.isEmpty {
			return false //this field accepts only alphanumeric chars
		}
		
		if let text = textField.text {
			let length = text.characters.count //check if this is still the way to do this
			
			switch length {
			case 2:
				textField.text = text.stringByAppendingString(":")
			default:
				break
			}
			if length > 4 {
				return false
			}
			
			return true
		}
		
		return false
	}
}