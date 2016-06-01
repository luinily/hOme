//
//  DevicesViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.

import UIKit

protocol DevicesViewControllerInput {
	func displayFetchedDevices(viewModel: Devices_FetchDevices_ViewModel)
}

protocol DevicesViewControllerOutput {
	func fetchDevices(request: Devices_FetchDevices_Request)
}



class DevicesViewController: UITableViewController {
		var output: DevicesViewControllerOutput!
		var router: DevicesRouter!
	
		private let _devicesSection = 0
		private let _newDeviceSection = 1
		private var _displayDevices: [Devices_FetchDevices_ViewModel.DisplayDevice] = []
	
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
			output.fetchDevices(request)
		}
	
		// MARK: Display logic
		func displayFetchedDevices(viewModel: Devices_FetchDevices_ViewModel) {
			_displayDevices = viewModel.displayedDevices
			tableView.reloadData()
		}
	
}

extension DevicesViewController: DevicesViewControllerInput { }


// MARK: UITableDataSource
extension DevicesViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case _devicesSection: return _displayDevices.count
		case _newDeviceSection: return 1
		default: return 0
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == _devicesSection {
			return makeDeviceCellForRow(indexPath.row)
		}
		
		//other cases (create new device)
		return makeNewDeviceCell()
		
	}
	
	private func makeDeviceCellForRow(row: Int) -> UITableViewCell {
		func setupCell(cell: UITableViewCell) {
			let device = _displayDevices[row]
			cell.textLabel?.text = device.name
		}
		
		if let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell") {
			setupCell(cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .Default, reuseIdentifier: "DeviceCell")
		cell.accessoryType = .DetailButton
		setupCell(cell)
		return cell
	}
	
	private func makeNewDeviceCell() -> UITableViewCell {
		func setupCell(cell: UITableViewCell) {
			cell.textLabel?.text = "Create New Device..."
		}
		
		if let cell = tableView.dequeueReusableCellWithIdentifier("NewDeviceCell") {
			setupCell(cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .Default, reuseIdentifier: "NewDeviceCell")
		setupCell(cell)
		
		return cell
	}
}

extension DevicesViewController: DevicesPresenterOutput {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		router.passDataToNextScene(segue)
	}
}
