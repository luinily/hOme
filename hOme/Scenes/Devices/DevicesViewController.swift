//
//  DevicesViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.

import UIKit

protocol DevicesViewControllerInput {
	func displayFetchedDevices(_ viewModel: Devices_FetchDevices_ViewModel)
}

protocol DevicesViewControllerOutput {
	func fetchDevices(_ request: Devices_FetchDevices_Request)
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
	func displayFetchedDevices(_ viewModel: Devices_FetchDevices_ViewModel) {
		_displayDevices = viewModel.displayedDevices
		//need to do the reload on the main thread or it gets very slow
		reloadTableDataInMainThread()
	}
	
	func reloadTableDataInMainThread() {
		DispatchQueue.main.async(execute: tableView.reloadData)
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
		func setupCell(_ cell: UITableViewCell) {
			let device = _displayDevices[row]
			cell.textLabel?.text = device.name
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") {
			setupCell(cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .default, reuseIdentifier: "DeviceCell")
		cell.accessoryType = .detailButton
		setupCell(cell)
		return cell
	}
	
	private func makeNewDeviceCell() -> UITableViewCell {
		func setupCell(_ cell: UITableViewCell) {
			cell.textLabel?.text = "Create New Device..."
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceCell") {
			setupCell(cell)
			return cell
		}
		
		let cell = UITableViewCell(style: .default, reuseIdentifier: "NewDeviceCell")
		setupCell(cell)
		
		return cell
	}
}

extension DevicesViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}

extension DevicesViewController: DevicesPresenterOutput {
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		router.passDataToNextScene(segue)
	}
}
