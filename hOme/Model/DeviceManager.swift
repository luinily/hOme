//
//  DeviceManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/01.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum DeviceManagerClassError: Error {
    case noDeviceNamesInRecord
    case couldNotFindDeviceInCK
}

class DeviceManager {
    private var _devices: [String: DeviceProtocol]
	private var _currentCKRecordName: String?
	
	var devices: [DeviceProtocol] {
		return _devices.values.sorted() {
			(device1, device2) in
			return device1.name < device2.name
			}
		}
    
    var count: Int {return _devices.count}
    var devicesNames: [String] {return _devices.keys.sorted()}
    
    init() {
        _devices = [String: DeviceProtocol]()
    }
	
	func CreateDevice(name: String, connector: Connector, getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) -> DeviceProtocol {
		
		let newName = Name(name: name, internalName: createNewUniqueName())
		let newDevice = Device(name: newName, connectorInternalName: connector.internalName, getCommand: getCommand, getConnector: getConnector)
		
		_devices[newName.internalName] = newDevice
		
		updateCloudKit()
		return newDevice
	}
    
	func deleteDevice(_ device: DeviceProtocol) {
		_devices.removeValue(forKey: device.internalName)
		CloudKitHelper.sharedHelper.remove(device)
		updateCloudKit()
		
	}
    
    func getDevice(internalName: String) -> DeviceProtocol? {
        return _devices[internalName] //returns nil if not in the dictionary (? magic)
    }
	
	func getDevices() -> [DeviceProtocol] {
		return _devices.values.sorted() {
			(lhand, rhand) in
			return lhand.name > rhand.name
		}
	}

}

//MARK: - Manager
extension DeviceManager: Manager {
	func getUniqueNameBase() -> String {
		return "Device"
	}
	
	func isNameUnique(_ name: String) -> Bool {
		return _devices.index(forKey: name) == nil
	}
}

//MARK: - CloudKitObject
extension DeviceManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		importDevicesFromCloudKitStore(getCommand: getCommand, getConnector: getConnector)
	}
	
	private func importDevicesFromCloudKitStore(getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) {
		let store = DeviceCloudKitStore()
		store.fetchDevices() {
			devices in
			for deviceInfo in devices {
				self.createAndAddDevice(deviceInfo: deviceInfo, getCommand: getCommand, getConnector: getConnector)
			}
		}
	}
	
	private func createAndAddDevice(deviceInfo: DeviceInfo, getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) {
		let device = Device(deviceInfo: deviceInfo, getCommand: getCommand, getConnector: getConnector)
		if self._devices.index(forKey: device.internalName) == nil {
			self._devices[device.internalName] = device
		}
	}
	
	func getNewCKRecordName() -> String {
		return "DeviceManager"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "DeviceManager"
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		var devicesRecordNames = [String]()
		for device in _devices {
			devicesRecordNames.append(device.1.getNewCKRecordName())
		}
		record["devicesRecordNames"] = devicesRecordNames
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
