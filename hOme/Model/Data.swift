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
	func createAndAddNewDeviceOfName(_ name: String, connector: Connector) -> DeviceProtocol {
		return _deviceManager.CreateDevice(name: name, connector: connector, getCommand: self.getCommand, getConnector: self.getConnector)
	}
	
	func deleteDevice(_ device: DeviceProtocol) {
		_deviceManager.deleteDevice(device)
	}
	
	func getDeviceOfInternalName(_ internalName: String) -> DeviceProtocol? {
		return _deviceManager.getDevice(internalName: internalName)
	}
	
	func getDeviceCount() -> Int {
		return _deviceManager.count
	}
	
	func getDevices() -> [DeviceProtocol] {
		return _deviceManager.getDevices()
	}
	
 	private func tryImportDeviceManager(_ completionHandler: (deviceManager: DeviceManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("DeviceManager") {
			(record) in
			do {
				var deviceManager: DeviceManager? = nil
				if let record = record {
					deviceManager = try DeviceManager(
						ckRecord: record,
						getCommand: self.getCommand,
						getConnector: self.getConnector
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
		return _sequenceManager.createSequence(name: name)
	}
	
	func deleteCommand(_ command: CommandProtocol) {
		_commandManager.deleteCommand(command)
	}
	
	func getCommand(internalName: String) -> CommandProtocol? {
		if let command = _commandManager.getCommand(internalName: internalName) {
			return command
		} else if let sequence = _sequenceManager.getSequence(internalName: internalName) {
			return sequence
		}
		return nil
	}
	
	func getCommandsOfDevice(deviceInternalName: String) -> [CommandProtocol]? {
		return _commandManager.getCommandsOfDevice(deviceInternalName: deviceInternalName)
	}
	
	func getCommandCountForDeviceOfInternalName(_ internalName: String) -> Int {
		return _commandManager.getCommandCountForDevice(deviceInternalName: internalName)
	}
	
	func getSequences() -> [Sequence] {
		return _sequenceManager.sequences
	}
	
	func getSequencesCount() -> Int {
		return _sequenceManager.count
	}
	
	func getSequence(internalName: String) -> Sequence? {
		return _sequenceManager.getSequence(internalName: internalName)
	}
	
	func createAndAddSequence(name: String) -> Sequence {
		return _sequenceManager.createSequence(name: name)
	}
	
	func deleteSequence(_ sequence: Sequence) {
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
						getConnector: self.getConnector
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
						getCommandOfUniqueName: self.getCommand
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
	
	func createAndAddNewConnector(_ type: ConnectorType, name: String, internalName: String) -> Connector? {
		return _connectorManager.createConnector(type: type, name: name, internalName: internalName)
	}
	
	func createAndAddNewConnector(_ type: ConnectorType, name: String) -> Connector? {
		return _connectorManager.createConnector(type: type, name: name)
	}
	
	func deleteConnector(_ connector: Connector) {
		_connectorManager.deleteConnector(connector)
	}
	
	func getConnector(internalName: String) -> Connector? {
		return _connectorManager.getCommunicator(internalName: internalName)
	}
	
	func getConnectorCount() -> Int {
		return _connectorManager.count
	}
	
	func getConnectors() -> [Connector] {
		return _connectorManager.connectors
	}
	
	func getConnectorsTypes() -> [ConnectorType] {
		return _connectorManager.getConnectorsTypes()
	}
	
	func getConnectorsByType() -> [ConnectorType: [Connector]] {
		return _connectorManager.getConnectorsByType()
	}
	
	func getConnectors(type: ConnectorType) -> [Connector] {
		return _connectorManager.getConnectors(type: type)
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
	
	func createAndAddNewScheduleCommand(_ command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int) -> ScheduleCommand {
		return _schedule.createAndAddNewScheduleCommand(command, days: days, hour: hour, minute: minute, getCommand: self.getCommand)
	}
	
	private func tryImportSequdule(_ completionHandler: (schedule: Schedule?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("Schedule") {
			(record) in
			do {
				var schedule: Schedule? = nil
				if let record = record {
					schedule = try Schedule(ckRecord: record, getCommandOfUniqueName: self.getCommand)
				}
				completionHandler(schedule: schedule)
			} catch {
				
			}
		}
	}
}

//MARK: - ButtonManager
extension Data {
	func createAndAddNewButton(_ buttonType: ButtonType, name: String, completionHandler: () -> Void) {
		return _buttonManager.createNewButton(buttonType: buttonType, name: name, completionHandler: completionHandler)
	}
	
	func deleteButton(_ button: Button) {
		_buttonManager.deleteButton(button)
	}
	
	func getButtonCount() -> Int {
		return _buttonManager.count
	}
	
	func getButtons() -> [Button] {
		return _buttonManager.buttons
	}
	
	func getButtonOfInternalName(_ internalName: String) -> Button? {
		return _buttonManager.getButton(internalName: internalName)
	}
	
	private func tryImportButtonManager(_ completionHandler: (buttonManager: ButtonManager?) -> Void) {
		CloudKitHelper.sharedHelper.importRecord("ButtonManager") {
			(record) in
			do {
				var buttonManager: ButtonManager? = nil
				if let record = record {
					buttonManager = try ButtonManager(ckRecord: record, getCommandOfUniqueName: self.getCommand)
				}
				completionHandler(buttonManager: buttonManager)
			} catch {
				
			}
		}
	}
	
	func handleOpenURL(_ url: URL) -> Bool {
//		return _buttonManager.handleOpenURL(url)
		return true
	}
}

//MARK: - Schedule
extension Data {
	func getScheduleCommandForTime(day: Weekday, hour: Int, minute: Int) -> [ScheduleCommand] {
		return _schedule.getCommands(day: day, hour: hour, minute: minute)
	}
}
