//
//  NameEditCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NameEditCell: UITableViewCell {
	@IBOutlet weak var edit: UITextField!
	private var _nameable: Nameable?
	var nameAble: Nameable? {
		get {return _nameable}
		set {
			_nameable = newValue
			edit.text = newValue?.name
		}
	}

	@IBAction func editingDidEnd(sender: AnyObject) {
		if let newName = edit.text {
			_nameable?.name = newName
		}
	}
}
