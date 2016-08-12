//
//  DeviceCommand.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/02/01.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum CommandClassError: Error {
	case noNameInCKRecord
	case noDeviceNameInCKRecord
}

enum ExecutionEffectOnDevice: Int {
	case none = 0
	case setDeviceOn = 1
	case setDeviceOff = 2
	case setDeviceOnOrOff = 3
}

protocol DeviceCommand: CommandProtocol {
	var deviceInternalName: String {get}
	var device: DeviceProtocol? {get}
	var executionEffectOnDevice: ExecutionEffectOnDevice {get set}
}
