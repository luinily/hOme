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
		doneButton.isEnabled = false
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SelectConectorCell {
			if let viewController = segue.destination as? SelectConnectorViewController {
				viewController.setOnConnectorSelected(onSelectedConnector)
				viewController.selectedConnector = cell.connector
			}
		}
	}
	
	func setOnClose(_ onClose: () -> Void) {
		_onClose = onClose
	}
	
	@IBAction func doneClick(_ sender: AnyObject) {
		if let connector = _connector {
			_ = application?.createNewDevice(name: _name, connector: connector)
			_onClose?()
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func cancelClick(_ sender: AnyObject) {
		_onClose?()
		self.dismiss(animated: true, completion: nil)
	}
	
	private func onChange(_ name: String, connector: Connector?) {
		_name = name
		_connector = connector
		
		doneButton.isEnabled = (name != "") && (connector != nil)
		updateView()
	}
	
	private func onSelectedConnector(_ connector: Connector) {
		onChange(_name, connector: connector)
	}
	
	private func showSelectConnector() {
		performSegue(withIdentifier: "ShowSelectConnector", sender: self)
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
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Device"
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		switch (indexPath as NSIndexPath).row {
		case 0:
			cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceNameCell")
			if let cell = cell as? NewDeviceNameCell {
				cell.onNameChanged = {
					name in
					self.onChange(name, connector: self._connector)
				}
				cell.name = _name
			}
		case 1:
			cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceConnectorCell")
			if let cell = cell as? SelectConectorCell {
				cell.connector = _connector
			}
		default:
			cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "NotFoundCell")
		}
		
		if let cell = cell {
			return cell
		}
		return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "NotFoundCell")
	}
}

//MARK: - UITableViewDelegate
extension NewDeviceViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
}
