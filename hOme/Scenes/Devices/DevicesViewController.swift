//
//  DevicesViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.

import UIKit

protocol DevicesViewControllerInput {
	func displayFetchedDevices(viewModel: Devices_FetchDevices_ViewModel)
	func presentDeviceDeleted(viewModel: Devices_Devicedeleted_ViewModel)
}

protocol DevicesViewControllerOutput {
	func fetchDevices(request: Devices_FetchDevices_Request)
	func deleteDevice(request: Devices_DeleteDevice_Request)
}



class DevicesViewController: UITableViewController {
	var output: DevicesViewControllerOutput!
	var router: DevicesRouter!
	
	private let _devicesSection = 0
	private let _newDeviceSection = 1
	private var _displayDevices: [DisplayDevice] = []
	
	// MARK: Object lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		DevicesConfigurator.sharedInstance.configure(self)
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchDevices()
	}
	
	// MARK: Event handling
	
	func fetchDevices() {
		let request = Devices_FetchDevices_Request()
		output.fetchDevices(request: request)
	}
	
	func deleteDevice(internalName: String) {
		let request = Devices_DeleteDevice_Request(internalName: internalName)
		output.deleteDevice(request: request)
	}
	
	// MARK: Display logic
	func reloadTableDataInMainThread() {
		DispatchQueue.main.async(execute: tableView.reloadData)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		router.passDataToNextScene(segue)
	}
}

extension DevicesViewController: DevicesViewControllerInput { }


// MARK: UITableDataSource
extension DevicesViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _devicesSection: return _displayDevices.count
		case _newDeviceSection: return 1
		default: return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath as NSIndexPath).section == _devicesSection {
			return makeDeviceCellForRow((indexPath as NSIndexPath).row)
		}
		
		//other cases (create new device)
		return makeNewDeviceCell()
		
	}
	
	private func makeDeviceCellForRow(_ row: Int) -> UITableViewCell {
		func setupCell(cell: UITableViewCell) {
			let device = _displayDevices[row]
			cell.textLabel?.text = device.name
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") {
			setupCell(cell: cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .default, reuseIdentifier: "DeviceCell")
		cell.accessoryType = .detailButton
		setupCell(cell: cell)
		return cell
	}
	
	private func makeNewDeviceCell() -> UITableViewCell {
		func setupCell(cell: UITableViewCell) {
			cell.textLabel?.text = "Create New Device..."
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceCell") {
			setupCell(cell: cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .default, reuseIdentifier: "NewDeviceCell")
		setupCell(cell: cell)
		
		return cell
	}
}

extension DevicesViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
			action, indexPath in
			let device = self._displayDevices[indexPath.row]
			self.deleteDevice(internalName: device.internalName)
		}
		
		return [delete]
	}

}

extension DevicesViewController: DevicesPresenterOutput {
	func displayFetchedDevices(viewModel: Devices_FetchDevices_ViewModel) {
		_displayDevices = viewModel.displayedDevices
		//need to do the reload on the main thread or it gets very slow
		reloadTableDataInMainThread()
	}
	
	func presentDeviceDeleted(viewModel: Devices_Devicedeleted_ViewModel) {
		if viewModel.couldDeleteDevice {
			_displayDevices = viewModel.remainingDevices
			reloadTableDataInMainThread()
		} else {
			print(viewModel.errorMessage) 
		}
	}
}
