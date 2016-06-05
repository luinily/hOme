//
//  DevicesWorker.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol DeviceStore {
	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void)
	func createDevice(name: String, connectorInternalName: String, completionHandler: (device: DeviceInfo?) -> Void)
}

class DevicesWorker {
	private var _deviceStore: DeviceStore
	var deviceStore: DeviceStore {
		get {return _deviceStore}
	}
	
	init(deviceStore: DeviceStore) {
		_deviceStore = deviceStore
	}
	
	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
		_deviceStore.fetchDevices(completionHandler)
	}
	
	func createDevice(name: String, connectorInternalName: String, completionHandler: (device: DeviceInfo?) -> Void) {
		_deviceStore.createDevice(name, connectorInternalName: connectorInternalName, completionHandler: completionHandler)
	}
}
