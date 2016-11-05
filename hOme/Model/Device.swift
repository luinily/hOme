//
//  Device.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/01.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum DeviceClassError: Error {
    case noNameInRecord
    case noCommunicatorNameInRecord
    case noCommunicatorOfThisName
    case noCommandTypeNameInRecord
    case noClassOfThisName
}



class Device: DeviceProtocol, Nameable {
    private var _name: Name
    private var _connectorInternalName: String
	private var _currentCKRecordName: String?
	private var _isOn = false
	private var _onCommandInternalName: String?
	private var _offCommandInternalName: String?
	private var _getCommand: (_ commandInternalName: String) -> CommandProtocol?
	private var _getConnector: (_ connectorInternalName: String) -> Connector?
	
	
	var onCommandName: String? {return _onCommandInternalName}
	var offCommandName: String? {return _offCommandInternalName}
	
	init (name: Name,
	      connectorInternalName: String,
	      getCommand: @escaping (_ commandInternalName: String) -> CommandProtocol?,
	      getConnector: @escaping (_ connectorInternalName: String) -> Connector?) {
		_name = name
        _connectorInternalName = connectorInternalName
		_getCommand = getCommand
		_getConnector = getConnector
		
		updateCloudKit()
    }
	
	init (ckRecordName: String,
	      getCommand: @escaping (_ commandInternalName: String) -> CommandProtocol?,
	      getConnector: @escaping (_ connectorInternalName: String) -> Connector?) {
		_name = Name(name: "", internalName: "")
		_connectorInternalName = ""
		_getCommand = getCommand
		_getConnector = getConnector
		_currentCKRecordName = ckRecordName

	}
	
	init (deviceInfo: DeviceInfo,
	      getCommand: @escaping (_ commandInternalName: String) -> CommandProtocol?,
	      getConnector: @escaping (_ connectorInternalName: String) -> Connector?) {
		_name = deviceInfo.name
		_connectorInternalName = deviceInfo.communicatorInternalName
		_onCommandInternalName = deviceInfo.onCommandInternalName
		_offCommandInternalName = deviceInfo.offCommandInternalName
		_getCommand = getCommand
		_getConnector = getConnector
		_currentCKRecordName = deviceInfo.name.internalName
	}
	
	func isEqualTo(_ other: DeviceProtocol) -> Bool {
		if let other = other as? Device {
			return other === self
		} else {
			return false
		}
	}
	
	private func getOffCommand() -> DeviceCommand? {
		if let commandName = _offCommandInternalName {
			return _getCommand(commandName) as? DeviceCommand
		}
		return nil
	}
	
	private func getOnCommand() -> DeviceCommand? {
		if let commandName = _onCommandInternalName {
			return _getCommand(commandName) as? DeviceCommand
		}
		return nil
	}
	
	private func getConnector() -> Connector? {
		return _getConnector(_connectorInternalName)
	}

	//MARK: - Nameable
	var name: String {
		get {return _name.name}
		set {
			_name.name = newValue
			updateCloudKit()
		}
	}
	var fullName: String {return _name.name}
	
	var internalName: String {return _name.internalName}

	//MARK: - CloudKitObject
	var connector: Connector? {
		get {return getConnector()}
	}
	var commandType: CommandType? { return connector?.getCommandType() }
	var isOn: Bool {return _isOn}
	var onCommand: DeviceCommand? {return getOnCommand()}
	var offCommand: DeviceCommand? {return getOffCommand()}
	
	func setConnector(_ connector: Connector) {
		_connectorInternalName = connector.internalName
		updateCloudKit()
	}
	
	func setOnCommand(_ command: DeviceCommand) {
		if (command.deviceInternalName == _name.internalName) || (command.executionEffectOnDevice == .setDeviceOn) {
			if command.internalName != _onCommandInternalName {
				_onCommandInternalName = command.internalName
				updateCloudKit()
				
			}
		}
	}
	
	func setOffCommand(_ command: DeviceCommand) {
		if (command.deviceInternalName == _name.internalName) || (command.executionEffectOnDevice == .setDeviceOff) {
			if command.internalName != _offCommandInternalName {
				_offCommandInternalName = command.internalName
				updateCloudKit()
			}
		}
	}
	
	func switchOn() {
		getOnCommand()?.execute()
	}
	
	func switchOff() {
		getOffCommand()?.execute()
	}
	
	func notifyCommandExecution(_ sender: DeviceCommand) {
		if sender.executionEffectOnDevice == .setDeviceOn {
			_isOn = true
		} else if sender.executionEffectOnDevice == .setDeviceOff {
			_isOn = false
		}
	}

	//MARK: - CloudKitObject
	convenience init(ckRecord: CKRecord,
	                 getCommand: @escaping (_ commandInternalName: String) -> CommandProtocol?,
	                 getConnector: @escaping (_ connectorInternalName: String) -> Connector?) throws {
		
		var needUpdateRecord = false
		self.init(ckRecordName: ckRecord.recordID.recordName,
		          getCommand: getCommand,
		          getConnector: getConnector)
			
		guard let name = ckRecord["Name"] as? String else {
			throw DeviceClassError.noNameInRecord
		}
		guard let connectorName = ckRecord["CommunicatorName"] as? String else {
			throw DeviceClassError.noCommunicatorNameInRecord
		}
		
		if let internalName = ckRecord["internalName"] as? String {
			_name = Name(name: name, internalName: internalName)
		} else {
			_name = Name(name: name, internalName: name)
			needUpdateRecord = true
		}
		
		self._connectorInternalName = connectorName
		self._onCommandInternalName = ckRecord["OnCommand"] as? String
		self._offCommandInternalName = ckRecord["OffCommand"] as? String
		
		if needUpdateRecord {
			updateCloudKit()
		}
	}
	
	func getNewCKRecordName() -> String {
		return "DeviceClass:"+_name.internalName
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "Device"
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		record["Name"] = _name.name as CKRecordValue?
		record["internalName"] = _name.internalName as CKRecordValue?
		record["CommunicatorName"] = _connectorInternalName as CKRecordValue?
		record["OnCommand"] = _onCommandInternalName as CKRecordValue?
		record["OffCommand"] = _offCommandInternalName as CKRecordValue?
	}
	
	func exportValues() {
		//nothing to do here
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
