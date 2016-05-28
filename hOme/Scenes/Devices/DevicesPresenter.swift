//
//  DevicesPresenter.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol DevicesPresenterInput {
	func presentFetchedDevices(response: Devices_FetchedDevices_Response)
}

protocol DevicesPresenterOutput: class {
	func displayFetchedDevices(viewModel: Devices_FetchDevices_ViewModel)
}

class DevicesPresenter: DevicesPresenterInput {
	weak var output: DevicesPresenterOutput!
	
	// MARK: Presentation logic
	
	func presentFetchedDevices(response: Devices_FetchedDevices_Response) {
		var displayedDevices: [Devices_FetchDevices_ViewModel.DisplayDevice] = []
		for device in response.devices {
			let name = device.name
			let internalName = device.internalName
			let displayDevice = Devices_FetchDevices_ViewModel.DisplayDevice(internalName: internalName, name: name)
			displayedDevices.append(displayDevice)
		}
		let viewModel = Devices_FetchDevices_ViewModel(displayedDevices: displayedDevices)
		output.displayFetchedDevices(viewModel)
	}
}
