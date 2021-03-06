//
//  DevicesInteractor.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol DevicesInteractorInput {
	func fetchDevices(request: Devices_FetchDevices_Request)
	func deleteDevice(request: Devices_DeleteDevice_Request)
}

protocol DevicesInteractorOutput {
	func presentFetchedDevices(response: Devices_FetchedDevices_Response)
	func presentDeviceDeleted(response: Devices_DeviceDeleted_Response)
}

class DevicesInteractor: DevicesInteractorInput {
	var output: DevicesInteractorOutput!
	var worker: DevicesWorker = DevicesWorker(deviceStore: DeviceCloudKitStore())
	
	// MARK: Business logic
	
	func fetchDevices(request: Devices_FetchDevices_Request) {
		worker.fetchDevices() {
			devices in
			let response = Devices_FetchedDevices_Response(devices: devices)
			self.output.presentFetchedDevices(response: response)
		}
	}
	
	func deleteDevice(request: Devices_DeleteDevice_Request) {
		worker.deleteDevice(internalName: request.internalName) {
			couldDeleteDevice in

			if couldDeleteDevice {
				self.respondCouldDeleteDevice()
			} else {
				self.respondCouldNotDeleteDevice()
			}
		}
	}
	
	private func respondCouldDeleteDevice() {
		worker.fetchDevices() {
			devices in
			let response = Devices_DeviceDeleted_Response(deviceDeleted: true, devices: [DeviceInfo]())
			self.output.presentDeviceDeleted(response: response)
		}
	}
	
	private func respondCouldNotDeleteDevice() {
		let response = Devices_DeviceDeleted_Response(deviceDeleted: false, devices: [DeviceInfo]())
		self.output.presentDeviceDeleted(response: response)
	}
}
