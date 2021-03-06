//
//  NameCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NameCell: UITableViewCell {
	@IBOutlet weak var edit: UITextField!
	private var _name: String = ""
	var name: String {
		get {return _name}
		set {
			_name = newValue
			edit.text = newValue
		}
	}
	
	private var _onNameChanged: ((_ newName: String) -> Void)?
	
	@IBAction func editingDidEnd(_ sender: AnyObject) {
		if let newName = edit.text {
			_name = newName
			_onNameChanged?(newName)
		}
	}
	
	func setOnNameChanged(_ onNameChanged: @escaping (_ newName: String) -> Void) {
		_onNameChanged = onNameChanged
	}
}
