//
//  OnOffCommand.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/23.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

struct OnOffCommand {
	private let _name = "OnOffCommand"
	private let _deviceInternalName: String
	private let _getDevice: (deviceInternalName: String) -> DeviceProtocol?
	var device: DeviceProtocol? {
		get {
			return _getDevice(deviceInternalName: _deviceInternalName)
		}
	}
	
	init (deviceInternalName: String, getDevice: (deviceInternalName: String) -> DeviceProtocol?) {
		_deviceInternalName = deviceInternalName
		_getDevice = getDevice
	}
	
	func getDeviceName() -> String? {
		return _getDevice(deviceInternalName: _deviceInternalName)?.name
	}
}

//MARK: - Nameable
extension OnOffCommand: Nameable {
	var name: String {
		get {return _name}
		set(name) {
			//nothing to do here
		}
	}
	
	var fullName: String {
		if let deviceName = getDeviceName() {
			return deviceName + ":" + name
		} else {
			return name
		}
	}
	
	var internalName: String {return _deviceInternalName+":"+name}
}

//MARK: - CommandProtocol
extension OnOffCommand: CommandProtocol {
	func execute() {
		if let device = device {
			if device.isOn {
				device.switchOff()
			} else {
				device.switchOn()
			}
		}
	}
}

//MARK: - DeviceCommand
extension OnOffCommand: DeviceCommand {
	var deviceInternalName: String {return _deviceInternalName}
	var executionEffectOnDevice: ExecutionEffectOnDevice {
		get {return .None}
		set(effect) {
			//nothing to do for this one
		}
	}
}
