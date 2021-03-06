//
//  Application.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class Application: NSObject, ConnectorUser {
    private var _data = Data()

    private var _mainTimer = Timer()
    private let _oneMinute: TimeInterval = 60
    private var _isRunning: Bool = false
	
	var running: Bool { return _isRunning }
	
	func tic() {
		if let currentTime = getCurrentTime() {
			executeCommandsFor(day: currentTime.day, hour: currentTime.hour, minute: currentTime.minute)
		} else {
			print("Could not get current time")
		}
	}
	
	private func executeCommandsFor(day: Weekday, hour: Int, minute: Int) {
		let commands = _data.getScheduleCommandForTime(day: day, hour: hour, minute: minute)
		
		print("MainTic("+String(hour)+":"+String(minute)+"): " + String(commands.count) + " commands to execute")
		
		for command in commands {
			command.execute()
		}
	}
	
	private func getCurrentTime() -> (day: Weekday, hour: Int, minute: Int)? {
		let date = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.weekday, .hour, .minute], from: date)
		
		if let day = Weekday(rawValue: (components.weekday! + 4)%6),
			   let hour = components.hour,
			   let minute = components.minute {
			return (day: day, hour: hour, minute: minute)
		}
		
		return nil
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

	//MARK: - Schedule
	func getSchedule() -> [Weekday: [ScheduleCommand]] {
		return _data.getSchedule()
	}
	
	func createAndAddNewScheduleCommand(command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int) -> ScheduleCommand {
		return _data.createAndAddNewScheduleCommand(command, days: days, hour: hour, minute: minute)
	}

	//MARK: - Commands
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

	//MARK: - Sequences
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

	//MARK: - Devices
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
	
	func fetchDevices(completionHandler: (_ devices: [DeviceProtocol]) -> Void) {
		let devices = _data.getDevices()
		completionHandler(devices)
	}
	
	func getDevice(internalName: String) -> DeviceProtocol? {
		return _data.getDeviceOfInternalName(internalName)
	}
	
	func deleteDevice(_ device: DeviceProtocol) {
		_data.deleteDevice(device)
	}

	//MARK: - Connectors
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

	//MARK: - Buttons
	func createNewButton(_ type: ButtonType, name: String, completionHandler: @escaping () -> Void) {
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
