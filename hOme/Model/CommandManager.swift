//
//  CommandManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/03.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum CommandManagerClassError: ErrorProtocol {
	case couldNotFindCommandDataInCK
	case clouldNotFindCommunicator
	case commandClassInvalid
}

class CommandManager {
	private var _commands: [String: CommandProtocol]
	private var _currentCKRecordName: String?
	
	init() {
		_commands = [String: CommandProtocol]()
	}
	
	init(ckRecordName: String) {
		_commands = [String: CommandProtocol]()
		_currentCKRecordName = ckRecordName
	}
	
	func createCommand(_ device: DeviceProtocol, name: String, commandType: CommandType?, getDevice: (deviceInternalName: String) -> DeviceProtocol?) -> CommandProtocol? {
		
		func createCommand(name: Name, device: DeviceProtocol, commandType: CommandType) -> DeviceCommand {
			var newCommand: DeviceCommand
			switch commandType {
			case .onOffCommand: newCommand = OnOffCommand(deviceInternalName: device.internalName, getDevice: getDevice)
			case .irkitCommand:
				newCommand = IRKitCommand(name: name, deviceInternalName: device.internalName, getDevice: getDevice, notifyDeviceOfExecution: device.notifyCommandExecution)
			}
			
			addCommand(newCommand)
			
			if newCommand is CloudKitObject {
				updateCloudKit()
			}
			
			return newCommand
		}
		
		let newName = Name(name: name, internalName: createNewUniqueName())
		if let commandType = commandType {
			return createCommand(name: newName, device: device, commandType: commandType)
		} else if let commandType = device.commandType {
			return createCommand(name: newName, device: device, commandType: commandType)
		}
		
		return nil
	}
	
	func deleteCommand(_ command: CommandProtocol) {
		if let ckCommand = command as? CloudKitObject {
			_commands[command.internalName] = nil
			CloudKitHelper.sharedHelper.remove(ckCommand)
			updateCloudKit()
		}
	}
	
	func getCommands() -> [String: CommandProtocol] {
		return _commands
	}
	
	func getCommand(internalName: String) -> CommandProtocol? {
		return _commands[internalName]
	}
	
	func getCommandsOfDevice(deviceInternalName: String) -> [CommandProtocol] {
		return _commands.values.filter() {
			command in
			if let command = command as? DeviceCommand {
				return command.deviceInternalName == deviceInternalName
			}
			return false
		}
	}
	
	private func addCommand(_ command: CommandProtocol) {
		if _commands.index(forKey: command.internalName) == nil {
			_commands[command.internalName] = command
		}
	}
	
	func getCommandCountForDevice(deviceInternalName: String) -> Int {
		return getCommandsOfDevice(deviceInternalName: deviceInternalName).count
	}
	
}

//MARK: - Manager
extension CommandManager: Manager {
	func getUniqueNameBase() -> String {
		return "Command"
	}
	
	func isNameUnique(_ name: String) -> Bool {
		return _commands.index(forKey: name) == nil
	}
}

//MARK: - CloudKitObject
extension CommandManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getDevice: (internalName: String) -> DeviceProtocol?, getConnector: (deviceName: String) -> Connector?) throws {
		self.init(ckRecordName: ckRecord.recordID.recordName)
		
		if let commandList = ckRecord["commandData"] as? [String] {
			for recordName in commandList {
				importCommand(recordName, getDevice: getDevice)
			}
		}
	}
	
	private func importCommand(_ commandRecordName: String, getDevice: (internalName: String) -> DeviceProtocol?) {
		CloudKitHelper.sharedHelper.importRecord(commandRecordName) {
			(record) in
			do {
				if let record = record {
					
					
					guard let deviceInternalName = record["deviceInternalName"] as? String else {
						throw CommandManagerClassError.commandClassInvalid
					}
					
					
					var commandExecutionNotifier: ((sender: DeviceCommand) -> Void)?
					if let device = getDevice(internalName: deviceInternalName) {
						commandExecutionNotifier = device.notifyCommandExecution
						
						self.addOnOffCommand(deviceInternalName, getDevice: getDevice) //Adds the command only if it does not exist already
					}
					
					var command: DeviceCommand? = nil
					
					let commandType = try self.getCommandType(record)
					
					switch commandType {
					case .irkitCommand:
						if let commandExecutionNotifier = commandExecutionNotifier {
							command = try IRKitCommand(ckRecord: record,
							                           getDevice: getDevice,
							                           notifyDeviceOfExecution: commandExecutionNotifier)
						}
					default:
						command = nil
					}
					
					if let command = command {
						if self._commands.index(forKey: command.internalName) == nil {
							self._commands[command.internalName] = command
						}
					}
					
				}
			} catch {
				
			}
		}
	}
	
	private func getCommandType(_ record: CKRecord) throws -> CommandType {
		guard let commandTypeRawValue = record["type"] as? Int else {
			throw CommandManagerClassError.commandClassInvalid
		}
		
		guard let commandType = CommandType(rawValue: commandTypeRawValue) else {
			throw CommandManagerClassError.commandClassInvalid
		}
		
		return commandType
	}
	
	private func addOnOffCommand(_ deviceInternalName: String, getDevice: (internalName: String) -> DeviceProtocol?) {
		if _commands[deviceInternalName] == nil {
			let command = OnOffCommand(deviceInternalName: deviceInternalName, getDevice: getDevice)
			addCommand(command)
		}

	}
	
	func getNewCKRecordName() -> String {
		return "CommandManager"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		_currentCKRecordName = record.recordID.recordName
		
		var commandList = [String]()
		
		for command in _commands.values {
			if let command = command as? CloudKitObject {
				commandList.append(command.getNewCKRecordName())
			}
		}
		
		record["commandData"] = commandList
	}
	
	func getCKRecordType() -> String {
		return "CommandManager"
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
