//
//  IRKitConnectorEditor.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitConnectorEditor: UITableViewController {
	
	@IBOutlet var table: UITableView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var bonjourName: UILabel!
	@IBOutlet weak var ipAddress: UILabel!
	@IBOutlet weak var ipCell: UITableViewCell!
	
	private var _connector: IRKitConnector?
	
	override func viewDidLoad() {
		reloadData()
	}
	
	@IBAction func nameEditingDidEnd(sender: AnyObject) {
		if let newName = nameTextField.text {
			_connector?.name = newName
		}
	}
	
	func setConnector(connector: IRKitConnector) {
		_connector = connector
	}
	
	private func reloadData() {
		nameTextField.text = _connector?.name
		bonjourName.text = _connector?.bonjourName
		ipAddress.text = _connector?.ipAddress
	}
}
