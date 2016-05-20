//
//  DeviceProtocol.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol DeviceProtocol: Nameable, CloudKitObject {
	var connector: Connector? {get}
	var commandType: CommandType? {get}
	var isOn: Bool {get}
	var onCommand: DeviceCommand? {get}
	var offCommand: DeviceCommand? {get}
	
	func setConnector(connector: Connector)
	func setOnCommand(command: DeviceCommand)
	func setOffCommand(command: DeviceCommand)
	func switchOn()
	func switchOff()
	func notifyCommandExecution(sender: DeviceCommand)
}

//MARK: - Equatable
extension Equatable where Self: DeviceProtocol {
}

func == (lhs: DeviceProtocol, rhs: DeviceProtocol) -> Bool {
	return (lhs.internalName == rhs.internalName)
}
