//
//  NewDeviceViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NewDeviceViewController: UIViewController {
	
	@IBOutlet var doneButton: UIBarButtonItem!
	@IBOutlet var table: UITableView!
	
	private var _name: String = "New Device"
	private var _connector: Connector?
	private var _onClose: (() -> Void)?
	
	override func viewDidLoad() {
		doneButton.enabled = false
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SelectConectorCell {
			if let viewController = segue.destinationViewController as? SelectConnectorViewController {
				viewController.setOnConnectorSelected(onSelectedConnector)
				viewController.selectedConnector = cell.connector
			}
		}
	}
	
	func setOnClose(onClose: () -> Void) {
		_onClose = onClose
	}
	
	@IBAction func doneClick(sender: AnyObject) {
		if let connector = _connector {
			application?.createNewDeviceOfName(_name, connector: connector)
			_onClose?()
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	@IBAction func cancelClick(sender: AnyObject) {
		_onClose?()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	private func onChange(name: String, connector: Connector?) {
		_name = name
		_connector = connector
		
		doneButton.enabled = (name != "") && (connector != nil)
		updateView()
	}
	
	private func onSelectedConnector(connector: Connector) {
		onChange(_name, connector: connector)
	}
	
	private func showSelectConnector() {
		performSegueWithIdentifier("ShowSelectConnector", sender: self)
	}
	
	private func updateView() {
		table.reloadData()
	}
}

//MARK: - ApplicationUser
extension NewDeviceViewController: ApplicationUser {
	
}

//MARK: - UITableViewDataSource
extension NewDeviceViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Device"
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		switch indexPath.row {
		case 0:
			cell = tableView.dequeueReusableCellWithIdentifier("NewDeviceNameCell")
			if let cell = cell as? NewDeviceNameCell {
				cell.onNameChanged = {
					name in
					self.onChange(name, connector: self._connector)
				}
				cell.name = _name
			}
		case 1:
			cell = tableView.dequeueReusableCellWithIdentifier("NewDeviceConnectorCell")
			if let cell = cell as? SelectConectorCell {
				cell.connector = _connector
			}
		default:
			cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "NotFoundCell")
		}
		
		if let cell = cell {
			return cell
		}
		return UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "NotFoundCell")
	}
}

//MARK: - UITableViewDelegate
extension NewDeviceViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	}
}
