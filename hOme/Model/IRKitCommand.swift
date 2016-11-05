//
//  IRKitCommand.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/01.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum IRKitCommandClassError: Error {
    case noFormatInCKRecord
    case noFrequenceInCKRecord
    case noDataInCKRecord
}

final class IRKitCommand: Nameable, CommandProtocol, DeviceCommand, Equatable, CloudKitObject {
	private var _name: Name
    private var _irSignal = IRKITSignal()
	private var _deviceInternalName: String
	private var _getDevice: (_ deviceInternalName: String) -> DeviceProtocol?
	private var _executionEffectOnDevice: ExecutionEffectOnDevice = .none
	private var _currentCKRecordName: String?
	private var _notifyDeviceOfExecution: (_ sender: DeviceCommand) -> Void

	var irSignal: IRKITSignal {return _irSignal}
	
	class func getCommandType() -> CommandType {
		return .irkitCommand
	}
	
	required init(name: Name, deviceInternalName: String, getDevice: @escaping (_ deviceInternalName: String) -> DeviceProtocol?, notifyDeviceOfExecution: @escaping (_ sender: DeviceCommand) -> Void) {
		_name = name
		_deviceInternalName = deviceInternalName
		_getDevice = getDevice
		_notifyDeviceOfExecution = notifyDeviceOfExecution
		updateCloudKit()
    }
	
	init(ckRecordName: String, getDevice: @escaping (_ deviceInternalName: String) -> DeviceProtocol?, notifyDeviceOfExecution: @escaping (_ sender: DeviceCommand) -> Void) {
		_name = Name(name: "", internalName: "")
		_currentCKRecordName = ckRecordName
		_deviceInternalName = ""
		_getDevice = getDevice
		_notifyDeviceOfExecution = notifyDeviceOfExecution
	}
	
	func isEqualTo(_ other: IRKitCommand) -> Bool {
		return (_name == other._name) && (_deviceInternalName == other._deviceInternalName) && (_irSignal == other._irSignal)
	}
	
	func setIRSignal(signal: IRKITSignal) {
		_irSignal = signal
		updateCloudKit()
	}
	
	func reloadIRSignal(completionHandler: @escaping () -> Void) {
		if let irKit = getConnector() {
			irKit.getData() {
				irSignal in
				self.setIRSignal(signal: irSignal)
				completionHandler()
			}
		}
	}
	
	private func getConnector() -> IRKitConnector? {
		return getDevice()?.connector as? IRKitConnector
	}
	
	private func getDeviceName() -> String? {
		return getDevice()?.name
	}
	
	private func getDevice() -> DeviceProtocol? {
		return _getDevice(_deviceInternalName)
	}

	//MARK: - Nameable
	var name: String {
		get {return _name.name}
		set {
			_name.name = newValue
			updateCloudKit()
		}
	}
	
	var internalName: String {return _name.internalName}
	
	var fullName: String {
		if let deviceName = getDeviceName() {
			return deviceName + ": " + _name.name
		} else {
			return _name.name
		}
	}

	//MARK: - CommandProtocol
	func execute() {
		print("Execute: " + fullName)
		if let connector = getConnector() {
			connector.sendDataToIRKit(irSignal) {
				self._notifyDeviceOfExecution(self)
			}
		}
	}

	//MARK: - DeviceCommand
	var deviceInternalName: String {return _deviceInternalName}
	var device: DeviceProtocol? {return getDevice()}
	var executionEffectOnDevice: ExecutionEffectOnDevice {
		get {return _executionEffectOnDevice}
		set(executionEffectOnDevice) {
			_executionEffectOnDevice = executionEffectOnDevice
			updateCloudKit()
		}
	}

	//MARK: - CloudKitObject
	convenience init (ckRecord: CKRecord, getDevice: @escaping (_ deviceInternalName: String) -> DeviceProtocol?, notifyDeviceOfExecution: @escaping (_ sender: DeviceCommand) -> Void) throws {
		self.init(ckRecordName: ckRecord.recordID.recordName, getDevice: getDevice, notifyDeviceOfExecution: notifyDeviceOfExecution)

		
		guard let name = ckRecord["name"] as? String else {
			throw CommandClassError.noNameInCKRecord
		}
		guard let format = ckRecord["format"] as? String else {
			throw IRKitCommandClassError.noFormatInCKRecord
		}
		guard let frequence = ckRecord["frequence"] as? Int else {
			throw IRKitCommandClassError.noFrequenceInCKRecord
		}
		
		guard let data = ckRecord["data"] as? [Int] else {
			throw IRKitCommandClassError.noDataInCKRecord
		}
		
		if let deviceInternalName = ckRecord["deviceInternalName"] as? String {
			_deviceInternalName = deviceInternalName
		} else if let deviceInternalName = ckRecord["deviceName"] as? String {
			_deviceInternalName = deviceInternalName
		}
		
		if let internalName = ckRecord["internalName"] as? String {
			_name = Name(name: name, internalName: internalName)
		} else {
			_name = Name(name: name, internalName: _deviceInternalName + name)
		}
		
		_irSignal.format = format
		_irSignal.frequence = frequence
		_irSignal.data = data
		
		if let onOffEffect = ckRecord["OnOffEffect"] as? Int {
			if let effect = ExecutionEffectOnDevice(rawValue: onOffEffect) {
				_executionEffectOnDevice = effect
			}
		}
	}
	
	
	func getNewCKRecordName () -> String {
		return internalName
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		record["deviceName"] = nil
		
		record["type"] = IRKitCommand.getCommandType().rawValue as CKRecordValue?
		record["name"] = _name.name as CKRecordValue?
		record["internalName"] = _name.internalName as CKRecordValue?
		record["deviceInternalName"] = _deviceInternalName as CKRecordValue?
		record["format"] = _irSignal.format as CKRecordValue?
		record["frequence"] = _irSignal.frequence as CKRecordValue?
		record["data"] = _irSignal.data as CKRecordValue?
		record["OnOffEffect"] = executionEffectOnDevice.rawValue as CKRecordValue?
	}
	
	func getCKRecordType() -> String {
		return "IRKitCommand"
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}

	static func == (lhs: IRKitCommand, rhs: IRKitCommand) -> Bool {
		return (lhs._name == rhs._name)
			&& (lhs._deviceInternalName == rhs._deviceInternalName)
			&& (lhs._irSignal == rhs._irSignal)
	}
}
