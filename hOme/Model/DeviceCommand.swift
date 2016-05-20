//
//  DeviceCommand.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/02/01.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum CommandClassError: ErrorType {
	case NoNameInCKRecord
	case NoDeviceNameInCKRecord
}

enum ExecutionEffectOnDevice: Int {
	case None = 0
	case SetDeviceOn = 1
	case SetDeviceOff = 2
	case SetDeviceOnOrOff = 3
}

protocol DeviceCommand: CommandProtocol {
	var deviceInternalName: String {get}
	var device: DeviceProtocol? {get}
	var executionEffectOnDevice: ExecutionEffectOnDevice {get set}
}
