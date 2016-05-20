//
//  Data.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation

class Data {
	private var _deviceManager = DeviceManager()
	private var _commandManager = CommandManager()
	private var _connectorManager = ConnectorManager()
	private var _sequenceManager = SequenceManager()
	private var _schedule = Schedule()
	private var _buttonManager = ButtonManager()
	
	init() {
		tryImportConnectorManager() {
			connectorManager in
			if let connectorManager = connectorManager {
				self._connectorManager = connectorManager
			} else {
				self._connectorManager.updateCloudKit()
			}
		}

		tryImportDeviceManager() {
			deviceManager in
			if let deviceManager = deviceManager {
				self._deviceManager = deviceManager
			} else {
				self._deviceManager.updateCloudKit()
			}
		}
		
		tryImportCommandManager() {
			commandManager in
			if let commandManager = commandManager {
				self._commandManager = commandManager
			} else {
				self._commandManager.updateCloudKit()
			}
		}
		
		tryImportSequenceManager() {
			sequenceManager in
			if let sequenceManager = sequenceManager {
				self._sequenceManager = sequenceManager
			} else {
				self._sequenceManager.updateCloudKit()
			}
		}
		
		tryImportButtonManager() {
			buttonManager in
			if let buttonManager = buttonManager {
				self._buttonManager = buttonManager
			} else {
				self._buttonManager.updateCloudKit()
			}
			
		}
		
		tryImportSequdule() {
			squedule in
			if let squedule = squedule {
				self._schedule = squedule
			} else {
				self._schedule.updateCloudKit()
			}
		}
	}
}

//MARK: - DeviceManager
extension Data {
	func createAndAddNewDeviceOfName(name: String, connector: Connector) -> DeviceProtocol {
		return _deviceManager.CreateDeviceOfName(name, connector: connector, getCommand: self.getCommandOfInternalName, getConnector: self.getConnectorOfInternalName)
	}
	
	func deleteDevice(device: DeviceProtocol) {
		_deviceManager.deleteDevice(device)
	}
	
	func getDeviceOfInternalName(internalName: String) -> DeviceProtocol? {
		return _deviceManager.getDeviceOfInternalName(internalName)
	}
	
	func getDeviceCount() -> Int {
		return _deviceManager.count
	}
	
	func getDevices() -> [DeviceProtocol] {
		return _deviceManager.getDevices()
	}
	
 	private func tryImportDeviceManager(completionHandler: (deviceManager: DeviceManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("DeviceManager") {
			(record) in
			do {
				var deviceManager: DeviceManager? = nil
				if let record = record {
					deviceManager = try DeviceManager(
						ckRecord: record,
						getCommand: self.getCommandOfInternalName,
						getConnector: self.getConnectorOfInternalName
					)
				}
				completionHandler(deviceManager: deviceManager)
			} catch {
				
			}
		}
	}
}

//MARK: - CommandManager SequenceManager
extension Data {
	
	func createAndAddNewCommand(device: DeviceProtocol, name: String, commandType: CommandType?) -> CommandProtocol? {
		return _commandManager.createCommand(device, name: name, commandType: commandType, getDevice: self.getDeviceOfInternalName)
	}
	
	func createAndAddNewSequence(name: String) -> Sequence {
		return _sequenceManager.createSequence(name)
	}
	
	func deleteCommand(command: CommandProtocol) {
		_commandManager.deleteCommand(command)
	}
	
	func getCommandOfInternalName(internalName: String) -> CommandProtocol? {
		if let command = _commandManager.getCommandOfInternalName(internalName) {
			return command
		} else if let sequence = _sequenceManager.getSequenceOfInternalName(internalName) {
			return sequence
		}
		return nil
	}
	
	func getCommandsOfDeviceOfInternalName(internalName: String) -> [CommandProtocol]? {
		return _commandManager.getCommandsOfDeviceOfInternalName(internalName)
	}
	
	func getCommandCountForDeviceOfInternalName(internalName: String) -> Int {
		return _commandManager.getCommandCountForDeviceOfInternalName(internalName)
	}
	
	func getSequences() -> [Sequence] {
		return _sequenceManager.sequences
	}
	
	func getSequencesCount() -> Int {
		return _sequenceManager.count
	}
	
	func getSequenceOfInternalName(internalName: String) -> Sequence? {
		return _sequenceManager.getSequenceOfInternalName(internalName)
	}
	
	func createAndAddSequenceOfName(name: String) -> Sequence {
		return _sequenceManager.createSequence(name)
	}
	
	func deleteSequence(sequence: Sequence) {
		_sequenceManager.deleteSequence(sequence)
	}
	
	private func tryImportCommandManager(completionHandler: (commandManager: CommandManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("CommandManager") {
			(record) in
			do {
				var commandManager: CommandManager? = nil
				if let record = record {
					commandManager = try CommandManager(
						ckRecord: record,
						getDevice: self.getDeviceOfInternalName,
						getConnector: self.getConnectorOfInternalName
					)
				}
				completionHandler(commandManager: commandManager)
			} catch {
				
			}
		}
	}
	
	private func tryImportSequenceManager(completionHandler: (sequenceManager: SequenceManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("SequenceManager") {
			(record) in
			do {
				var sequenceManager: SequenceManager? = nil
				if let record = record {
					sequenceManager = try SequenceManager(
						ckRecord: record,
						getCommandOfUniqueName: self.getCommandOfInternalName
					)
				}
				completionHandler(sequenceManager: sequenceManager)
			} catch {
				
			}
		}
	}
}

//MARK: - ConnectorManager
extension Data {
	
	func createAndAddNewConnector(type: ConnectorType, name: String, internalName: String) -> Connector? {
		return _connectorManager.createConnector(type, name: name, internalName: internalName)
	}
	
	func createAndAddNewConnector(type: ConnectorType, name: String) -> Connector? {
		return _connectorManager.createConnector(type, name: name)
	}
	
	func deleteConnector(connector: Connector) {
		_connectorManager.deleteConnector(connector)
	}
	
	func getConnectorOfInternalName(internalName: String) -> Connector? {
		return _connectorManager.getCommunicatorOfUniqueName(internalName)
	}
	
	func getConnectorCount() -> Int {
		return _connectorManager.count
	}
	
	func getConnectors() -> [Connector] {
		return _connectorManager.connectors
	}
	
	func getConnectorsOfType(type: ConnectorType) -> [Connector] {
		return _connectorManager.getConnectorsOfType(type)
	}
	
	private func tryImportConnectorManager(completionHandler: (communicatorManager: ConnectorManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("CommunicatorManager") {
			(record) in
			do {
				var communicatorManager: ConnectorManager? = nil
				if let record = record {
					communicatorManager = try ConnectorManager(ckRecord: record)
				}
				completionHandler(communicatorManager: communicatorManager)
			} catch {
				
			}
		}
	}
}

//MARK: - Schedule
extension Data {
	func getSchedule() -> [Weekday: [ScheduleCommand]] {
		return _schedule.getSchedule()
	}
	
	func createAndAddNewScheduleCommand(command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int) -> ScheduleCommand {
		return _schedule.createAndAddNewScheduleCommand(command, days: days, hour: hour, minute: minute, getCommand: self.getCommandOfInternalName)
	}
	
	private func tryImportSequdule(completionHandler: (schedule: Schedule?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("Schedule") {
			(record) in
			do {
				var schedule: Schedule? = nil
				if let record = record {
					schedule = try Schedule(ckRecord: record, getCommandOfUniqueName: self.getCommandOfInternalName)
				}
				completionHandler(schedule: schedule)
			} catch {
				
			}
		}
	}
}

//MARK: - ButtonManager
extension Data {
	func createAndAddNewButton(buttonType: ButtonType, name: String, completionHandler: () -> Void) {
		return _buttonManager.createNewButton(buttonType, name: name, completionHandler: completionHandler)
	}
	
	func deleteButton(button: Button) {
		_buttonManager.deleteButton(button)
	}
	
	func getButtonCount() -> Int {
		return _buttonManager.count
	}
	
	func getButtons() -> [Button] {
		return _buttonManager.buttons
	}
	
	func getButtonOfInternalName(internalName: String) -> Button? {
		return _buttonManager.getButtonOfInternalName(internalName)
	}
	
	private func tryImportButtonManager(completionHandler: (buttonManager: ButtonManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("ButtonManager") {
			(record) in
			do {
				var buttonManager: ButtonManager? = nil
				if let record = record {
					buttonManager = try ButtonManager(ckRecord: record, getCommandOfUniqueName: self.getCommandOfInternalName)
				}
				completionHandler(buttonManager: buttonManager)
			} catch {
				
			}
		}
	}
	
	func handleOpenURL(url: NSURL) -> Bool {
//		return _buttonManager.handleOpenURL(url)
		return true
	}
}

//MARK: - Schedule
extension Data {
	func getScheduleCommandForTime(day: Weekday, hour: Int, minute: Int) -> [ScheduleCommand]? {
		return _schedule.getCommandsForMinute(day, hour: hour, minute: minute)
	}
}
