//
//  DeviceCloudKitStore.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/11.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

class DeviceCloudKitStore: DeviceStore {
	private var cloudKitWrapper: CloudKitWrapperProtocol
	private let deviceRecordType = "Device"
	
	init(cloudKitWrapper: CloudKitWrapperProtocol) {
		self.cloudKitWrapper = cloudKitWrapper
		
	}
	
	init() {
		self.cloudKitWrapper = CloudKitWrapper()
	}
	
	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
		cloudKitWrapper.fetchRecordsOfType(deviceRecordType) {
			records in
			let devices = self.convertRecordsToDeviceInfo(records)
			completionHandler(devices: devices)
		}
	}
	
	private func convertRecordsToDeviceInfo(records: [[String: Any]]) -> [DeviceInfo] {
		var result = [DeviceInfo]()
		for record in records {
			if let deviceInfo = convertRecordToDeviceInfo(record) {
				result.append(deviceInfo)
			}
		}
		return result
	}
	
	private func convertRecordToDeviceInfo(record: [String: Any]) -> DeviceInfo? {
		do {
			return try DeviceInfo(record: record)
		} catch {
			return nil
		}
	}
	
	func createDevice(name: String, connectorInternalName: String, completionHandler: (couldCreateDevice: Bool) -> Void) {
		let deviceInfo = makeDeviceInfo(name, connectorInternalName: connectorInternalName)
		let dic = deviceInfo.toDictionary()
		cloudKitWrapper.createRecordOfType(deviceRecordType, data: dic) {
			(couldCreateDevice, error) in
			if couldCreateDevice {
				completionHandler(couldCreateDevice: true)
			} else {
				if error == CloudKitError.RecordAlreadyExisting {
					self.createDevice(name, connectorInternalName: connectorInternalName, completionHandler: completionHandler)
				} else {
					completionHandler(couldCreateDevice: false)
				}
			}
			
		}
	}
	
	private func makeDeviceInfo(name: String, connectorInternalName: String) -> DeviceInfo {
		let name = Name(name: name, internalName: makeNewInternalName())
		return DeviceInfo(name: name, communicatorInternalName: connectorInternalName, offCommandInternalName: "", onCommandInternalName: "")
	}
	
	private func convertDeviceInfoToDic(info: DeviceInfo) -> [String: Any] {
		return info.toDictionary()
	}
	
	private func makeNewInternalName() -> String {
		return createNewUniqueName()
	}
	
}

extension DeviceCloudKitStore: Manager {
	func getUniqueNameBase() -> String {
		return deviceRecordType
	}
	
	func isNameUnique(name: String) -> Bool {
		return true
	}
}
