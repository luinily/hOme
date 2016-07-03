//
//  Application.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class Application: NSObject {
    private var _data = Data()

    private var _mainTimer = Timer()
    private let _oneMinute: TimeInterval = 60
    private var _isRunning: Bool = false
	
	var running: Bool { return _isRunning }
	
	func tic() {
		let date = Date()
		let calendar = Calendar.current()
		let components = calendar.components([.weekday, .hour, .minute], from: date)
		
		let hour = components.hour
		let minute = components.minute
		
		print("MainTic("+String(hour)+":"+String(minute)+")")
		if let day = Weekday(rawValue: (components.weekday! + 4)%6), hour = hour, minute = minute {
			if let commands = _data.getScheduleCommandForTime(day: day, hour: hour, minute: minute) {
				for command in commands {
					command.execute()
				}
			}
		}
	}
	
	
	
	private func mainLoopTic() {
		_mainTimer = Timer.scheduledTimer(timeInterval: _oneMinute, target: self, selector: #selector(Application.tic), userInfo: nil, repeats: true)
		_mainTimer.fire()
	}
	
	func start() {
		mainLoopTic()
		_isRunning = true
	}
	
	func stop() {
		_mainTimer.invalidate()
		_isRunning = false
	}
}

//MARK: - Schedule
extension Application {

	//--- schedule
	func getSchedule() -> [Weekday: [ScheduleCommand]] {
		return _data.getSchedule()
	}
	
	func createAndAddNewScheduleCommand(command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int) -> ScheduleCommand {
		return _data.createAndAddNewScheduleCommand(command, days: days, hour: hour, minute: minute)
	}
}

//MARK: - Commands
extension Application {
	//---- commands
	func getCommandsOfDevice(deviceInternalName: String) -> [CommandProtocol]? {
		return _data.getCommandsOfDevice(deviceInternalName: deviceInternalName)
	}
	
	func getCommandCountForDevice(deviceInternalName: String) -> Int {
		return _data.getCommandCountForDeviceOfInternalName(deviceInternalName)
	}

	func getCommand(internalName: String) -> CommandProtocol? {
		return _data.getCommand(internalName: internalName)
	}
	
	func createNewCommand(device: DeviceProtocol, name: String) -> CommandProtocol? {
		return _data.createAndAddNewCommand(device: device, name: name, commandType: device.commandType)
	}
	
	func deleteCommand(_ command: CommandProtocol) {
		_data.deleteCommand(command)
	}
}

//MARK: - Sequences
extension Application {
	func getSequences() -> [Sequence] {
		return _data.getSequences()
	}
	
	func getSequenceCount() -> Int {
		return _data.getSequencesCount()
	}
	
	func createNewSequence(name: String) -> Sequence? {
		return _data.createAndAddSequence(name: name)
	}
	
	func getSequence(internalName: String) -> Sequence? {
		return _data.getSequence(internalName: internalName)
	}
	
	func deleteSequence(_ sequence: Sequence) {
		_data.deleteSequence(sequence)
	}
}

//MARK: - Devices
extension Application {
	func createNewDevice(name: String, connector: Connector) -> DeviceProtocol {
		let device = _data.createAndAddNewDeviceOfName(name, connector: connector)
		_ = _data.createAndAddNewCommand(device: device, name: "OnOffCommand", commandType: .onOffCommand)
		
		return device
	}
	
	func getDeviceCount() -> Int {
		return _data.getDeviceCount()
	}
	
	func getDevices() -> [DeviceProtocol] {
		return _data.getDevices()
	}
	
	func fetchDevices(completionHandler: (devices: [DeviceProtocol]) -> Void) {
		let devices = _data.getDevices()
		completionHandler(devices: devices)
	}
	
	func getDevice(internalName: String) -> DeviceProtocol? {
		return _data.getDeviceOfInternalName(internalName)
	}
	
	func deleteDevice(_ device: DeviceProtocol) {
		_data.deleteDevice(device)
	}
}

//MARK: - Connectors
extension Application: ConnectorUser {
	func createAndAddNewConnector(type: ConnectorType, name: String, internalName: String) -> Connector? {
		return _data.createAndAddNewConnector(type, name: name, internalName: internalName)
	}
	
	func createAndAddNewConnector(type: ConnectorType, name: String) -> Connector? {
		return _data.createAndAddNewConnector(type, name: name)
	}
	
	func deleteConnector(_ connector: Connector) {
		_data.deleteConnector(connector)
	}
	
	func getConnectorCount() -> Int {
		return _data.getConnectorCount()
	}
	
	func getConnectors() -> [Connector] {
		return _data.getConnectors()
	}
	
	func getConnectorsTypes() -> [ConnectorType] {
		return _data.getConnectorsTypes()
	}
	
	func getConnectorsByType() -> [ConnectorType: [Connector]] {
		return _data.getConnectorsByType()
	}
	
	func getConnectors(type: ConnectorType) -> [Connector] {
		return _data.getConnectors(type: type)
	}
	
	func getConnector(internalName: String) -> Connector? {
		return _data.getConnector(internalName: internalName)
	}
	
}

//MARK: - Buttons
extension Application {
	//--- buttons ----
	func createNewButton(_ type: ButtonType, name: String, completionHandler: () -> Void) {
		_data.createAndAddNewButton(type, name: name, completionHandler: completionHandler)
	}
	
	func deleteButton(_ button: Button) {
		_data.deleteButton(button)
	}
	
	func getButtonsCount() -> Int {
		return _data.getButtonCount()
	}
	
	func getButtons() -> [Button] {
		return _data.getButtons()
	}
	
	func getButton(internalName: String) -> Button? {
		return _data.getButtonOfInternalName(internalName)
	}
	
	func handleOpenURL(_ url: URL) -> Bool {
		return _data.handleOpenURL(url)
	}
}
