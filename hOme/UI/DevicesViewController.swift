//
//  DevicesViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class DevicesViewController: UITableViewController {
	
	@IBOutlet weak var devicesTable: UITableView!
	private let _sectionDevices = 0
	private let _sectionNewDevice = 1
	private var _devices = [DeviceProtocol]()
	
	override func viewDidLoad() {

	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? DeviceCell {
			if let deviceVC = segue.destinationViewController as? DeviceViewController,
				device = cell.device {
				deviceVC.setDevice(device)
			}
		} else if let viewController = segue.destinationViewController as? UINavigationController {
			if let newDeviceVC = viewController.visibleViewController as? NewDeviceViewController {
				newDeviceVC.setOnClose(updateView)
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		updateView()
	}
	
	private func showNewDeviceView() {
		performSegueWithIdentifier("ShowNewDeviceSegue", sender: self)
	}
	
	private func showDeviceView(device: DeviceProtocol) {
		performSegueWithIdentifier("showDeviceSegue", sender: self)
	}
	
	private func updateView() {
		devicesTable.reloadData()
	}
	
}

//MARK: - ApplicationUser
extension DevicesViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension DevicesViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == _sectionDevices {
			if let application = application {
				_devices = application.getDevices()
				return _devices.count
			}
		} else if section == _sectionNewDevice {
			return 1
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionDevices {
			return "Devices"
		}
		return ""
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell?
		if indexPath.section == _sectionDevices {
			cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell")
			if let cell = cell as? DeviceCell {
				cell.device = _devices[indexPath.row]
			}
		} else {
			cell = tableView.dequeueReusableCellWithIdentifier("NewDeviceCell")
		}
		

		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
		}
	}
}

// MARK: Table Delegate
extension DevicesViewController {
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .Destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application {
				application.deleteDevice(self._devices[indexPath.row])
				tableView.reloadData()
			}
		}
		
		return [delete]
	}
}
