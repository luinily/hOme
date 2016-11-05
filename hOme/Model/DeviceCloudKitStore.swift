//
//  DeviceCloudKitStore.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/11.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

class DeviceCloudKitStore: DeviceStore, Manager {
	private var cloudKitWrapper: CloudKitWrapperProtocol
	private let deviceRecordType = "Device"
	
	init(cloudKitWrapper: CloudKitWrapperProtocol) {
		self.cloudKitWrapper = cloudKitWrapper
		
	}
	
	init() {
		self.cloudKitWrapper = CloudKitWrapper()
	}
	
	func fetchDevices(completionHandler: @escaping (_ devices: [DeviceInfo]) -> Void) {
		cloudKitWrapper.fetchRecordsOfType(type: deviceRecordType) {
			records in
			let devices = self.convertRecordsToDeviceInfo(records: records)
			completionHandler(devices)
		}
	}
	
	private func convertRecordsToDeviceInfo(records: [[String: Any]]) -> [DeviceInfo] {
		var result = [DeviceInfo]()
		for record in records {
			if let deviceInfo = convertRecordToDeviceInfo(record: record) {
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
	
	func createDevice(name: String, connectorInternalName: String, completionHandler: @escaping (_ couldCreateDevice: Bool) -> Void) {
		let deviceInfo = makeDeviceInfo(name: name, connectorInternalName: connectorInternalName)
		let dic = deviceInfo.toDictionary()
		cloudKitWrapper.createRecordOfType(type: deviceRecordType, data: dic) {
			(couldCreateDevice, error) in
			if couldCreateDevice {
				completionHandler(true)
			} else {
				if error == CloudKitError.recordAlreadyExisting {
					self.createDevice(name: name, connectorInternalName: connectorInternalName, completionHandler: completionHandler)
				} else {
					completionHandler(false)
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
	
	func deleteDevice(internalName: String, completionHandler: @escaping (_ couldDeleteDevice: Bool) -> Void) {
		cloudKitWrapper.deleteRecord(recordName: internalName, completionHandler: (completionHandler))
	}

	func getUniqueNameBase() -> String {
		return deviceRecordType
	}
	
	func isNameUnique(_ name: String) -> Bool {
		return true
	}
}
