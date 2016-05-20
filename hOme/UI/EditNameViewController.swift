//
//  EditNameViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/02.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class EditNameViewController: UITableViewController {
	var name: String = ""
	
	@IBOutlet weak var nameEdit: UITextField!
	
	@IBAction func onNameEdited(sender: AnyObject) {
		if let text = nameEdit.text {
			name = text
		}
	}
	
	override func viewDidLoad() {
		nameEdit.text = name
	}
	
}
