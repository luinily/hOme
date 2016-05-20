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

    private var _mainTimer = NSTimer()
    private let _oneMinute: NSTimeInterval = 60
    private var _isRunning: Bool = false
	
	var running: Bool { return _isRunning }
	
	func tic() {
		let date = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Weekday, .Hour, .Minute], fromDate: date)
		
		let hour = components.hour
		let minute = components.minute
		
		print("MainTic("+String(hour)+":"+String(minute)+")")
		if let day = Weekday(rawValue: (components.weekday + 4)%6) {
			if let commands = _data.getScheduleCommandForTime(day, hour: hour, minute: minute) {
				for command in commands {
					command.execute()
				}
			}
		}
	}
	
	
	
	private func mainLoopTic() {
		_mainTimer = NSTimer.scheduledTimerWithTimeInterval(_oneMinute, target: self, selector: #selector(Application.tic), userInfo: nil, repeats: true)
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
	func getCommandsOfDeviceOfInternalName(internalName: String) -> [CommandProtocol]? {
		return _data.getCommandsOfDeviceOfInternalName(internalName)
	}
	
	func getCommandCountForDeviceOfInternalName(internalName: String) -> Int {
		return _data.getCommandCountForDeviceOfInternalName(internalName)
	}
	
	func getCommandOfName(internalName: String) -> CommandProtocol? {
		return _data.getCommandOfInternalName(internalName)
	}
	
	func getCommandOfInternalName(internalName: String) -> CommandProtocol? {
		return _data.getCommandOfInternalName(internalName)
	}
	
	func createNewCommand(device: DeviceProtocol, name: String) -> CommandProtocol? {
		return _data.createAndAddNewCommand(device, name: name, commandType: device.commandType)
	}
	
	func deleteCommand(command: CommandProtocol) {
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
		return _data.createAndAddSequenceOfName(name)
	}
	
	func getSequenceOfInternalName(internalName: String) -> Sequence? {
		return _data.getSequenceOfInternalName(internalName)
	}
	
	func deleteSequence(sequence: Sequence) {
		_data.deleteSequence(sequence)
	}
}

//MARK: - Devices
extension Application {
	func createNewDeviceOfName(name: String, connector: Connector) -> DeviceProtocol {
		let device = _data.createAndAddNewDeviceOfName(name, connector: connector)
		_data.createAndAddNewCommand(device, name: "OnOffCommand", commandType: .onOffCommand)
		
		return device
	}
	
	func getDeviceCount() -> Int {
		return _data.getDeviceCount()
	}
	
	func getDevices() -> [DeviceProtocol] {
		return _data.getDevices()
	}
	
	func getDeviceOfInternalName(internalName: String) -> DeviceProtocol? {
		return _data.getDeviceOfInternalName(internalName)
	}
	
	func deleteDevice(device: DeviceProtocol) {
		_data.deleteDevice(device)
	}
}

//MARK: - Connectors
extension Application {
	func createAndAddNewConnector(type: ConnectorType, name: String, internalName: String) -> Connector? {
		return _data.createAndAddNewConnector(type, name: name, internalName: internalName)
	}
	
	func createAndAddNewConnector(type: ConnectorType, name: String) -> Connector? {
		return _data.createAndAddNewConnector(type, name: name)
	}
	
	func deleteConnector(connector: Connector) {
		_data.deleteConnector(connector)
	}
	
	func getConnectorCount() -> Int {
		return _data.getConnectorCount()
	}
	
	func getConnectors() -> [Connector] {
		return _data.getConnectors()
	}
	
	func getConnectorsOfType(type: ConnectorType) -> [Connector] {
		return _data.getConnectorsOfType(type)
	}
	
	func getConnectorOfInternalName(internalName: String) -> Connector? {
		return _data.getConnectorOfInternalName(internalName)
	}
	
}

//MARK: - Buttons
extension Application {
	//--- buttons ----
	func createNewButton(type: ButtonType, name: String, completionHandler: () -> Void) {
		_data.createAndAddNewButton(type, name: name, completionHandler: completionHandler)
	}
	
	func deleteButton(button: Button) {
		_data.deleteButton(button)
	}
	
	func getButtonsCount() -> Int {
		return _data.getButtonCount()
	}
	
	func getButtons() -> [Button] {
		return _data.getButtons()
	}
	
	func getButtonOfInternalName(internalName: String) -> Button? {
		return _data.getButtonOfInternalName(internalName)
	}
	
	func handleOpenURL(url: NSURL) -> Bool {
		return _data.handleOpenURL(url)
	}
}
