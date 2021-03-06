//
//  OnOffCommand.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/23.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

struct OnOffCommand: Nameable, CommandProtocol, DeviceCommand {
	private let _name = "OnOffCommand"
	private let _deviceInternalName: String
	private let _getDevice: (_ deviceInternalName: String) -> DeviceProtocol?
	var device: DeviceProtocol? {
		get {
			return _getDevice(_deviceInternalName)
		}
	}
	
	init (deviceInternalName: String, getDevice: @escaping (_ deviceInternalName: String) -> DeviceProtocol?) {
		_deviceInternalName = deviceInternalName
		_getDevice = getDevice
	}
	
	func getDeviceName() -> String? {
		return _getDevice(_deviceInternalName)?.name
	}

	//MARK: - Nameable
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

	//MARK: - CommandProtocol
	func execute() {
		if let device = device {
			if device.isOn {
				device.switchOff()
			} else {
				device.switchOn()
			}
		}
	}

	//MARK: - DeviceCommand
	var deviceInternalName: String {return _deviceInternalName}
	var executionEffectOnDevice: ExecutionEffectOnDevice {
		get {return .none}
		set(effect) {
			//nothing to do for this one
		}
	}
}
