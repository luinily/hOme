//
//  DeviceManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/01.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum DeviceManagerClassError: ErrorType {
    case NoDeviceNamesInRecord
    case CouldNotFindDeviceInCK
}

class DeviceManager {
    private var _devices: [String: DeviceProtocol]
	private var _currentCKRecordName: String?
	
	var devices: [DeviceProtocol] {
		return _devices.values.sort() {
			(device1, device2) in
			return device1.name < device2.name
			}
		}
    
    var count: Int {return _devices.count}
    var devicesNames: [String] {return _devices.keys.sort()}
    
    init() {
        _devices = [String: DeviceProtocol]()
    }
	
	func CreateDeviceOfName(name: String, connector: Connector, getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) -> DeviceProtocol {
		
		let newName = Name(name: name, internalName: createNewUniqueName())
		let newDevice = Device(name: newName, connectorInternalName: connector.internalName, getCommand: getCommand, getConnector: getConnector)
		
		_devices[newName.internalName] = newDevice
		
		updateCloudKit()
		return newDevice
	}
    
	func deleteDevice(device: DeviceProtocol) {
		_devices.removeValueForKey(device.internalName)
		CloudKitHelper.sharedHelper.remove(device)
		updateCloudKit()
		
	}
    
    func getDeviceOfInternalName(deviceInternalName: String) -> DeviceProtocol? {
        return _devices[deviceInternalName] //returns nil if not in the dictionary (? magic)
    }
	
	func getDevices() -> [DeviceProtocol] {
		return _devices.values.sort() {
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
	
	func isNameUnique(name: String) -> Bool {
		return _devices.indexForKey(name) == nil
	}
}

//MARK: - CloudKitObject
extension DeviceManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommand: (commandInternalName: String) -> CommandProtocol?, getConnector: (connectorInternalName: String) -> Connector?) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let devicesRecordNames = ckRecord["devicesRecordNames"] as? [String] else {
			throw DeviceManagerClassError.NoDeviceNamesInRecord
		}
		
		for recordName in devicesRecordNames {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						let device = try Device(ckRecord: record, getCommand: getCommand, getConnector: getConnector)
						if self._devices.indexForKey(device.internalName) == nil {
							self._devices[device.internalName] = device
						}
					}
				} catch {
				}
			}
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
	
	func setUpCKRecord(record: CKRecord) {
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
