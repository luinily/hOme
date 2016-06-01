//
//  DeviceMemStore.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

//class DeviceMemStore: DeviceStore {
//	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
//		if let application = application {
//			application.fetchDevices(completionHandler)
//		} else {
//			completionHandler(devices: [])
//		}
//	}
//}

//extension DeviceMemStore: ApplicationUser { }

struct DeviceInfo {
	var name: Name
	var communicatorInternalName: String
	var offCommandInternalName: String
	var onCommandInternalName: String
}

class DeviceCloudKitStore: DeviceStore {
	private var _container: CKContainer
	private var _dataBase: CKDatabase
	
	init() {
		_container = CKContainer(identifier: "iCloud.com.YoannColdefy.IRKitApp")
		_dataBase = _container.privateCloudDatabase
	}
	
	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
		let query = createQueryForRecordType("Device")
		_dataBase.performQuery(query, inZoneWithID: nil) {
			(records, error) in
			self.receivedRecordsFromCloudkit(records, error: error, completionHandler: completionHandler)
		}
	}

	private func receivedRecordsFromCloudkit(records: [CKRecord]?, error: NSError?, completionHandler: (devices: [DeviceInfo]) -> Void) {
		if let records = records {
			let devices = convertRecordsToDevice(records)
			completionHandler(devices: devices)
		} else {
			print(error)
			completionHandler(devices: [])
		}
	}
	
	private func convertRecordsToDevice(records: [CKRecord]) -> [DeviceInfo] {
		var result = [DeviceInfo]()
		for record in records {
			let device = convertRecordToDevice(record)
			if let device = device {
				result.append(device)
			}
		}
		return result
	}
	
	private func convertRecordToDevice(record: CKRecord) -> DeviceInfo? {
		guard let name = record["Name"] as? String else {
			return nil
		}
		guard let internalName = record["internalName"] as? String else {
			return nil
		}
		guard let communicatorInternalName = record["CommunicatorName"] as? String else {
			return nil
		}
		guard let offCommandInternalName = record["OffCommand"] as? String else {
			return nil
		}
		guard let onCommandInternalName = record["OnCommand"] as? String else {
			return nil
		}
		let deviceName = Name(name: name, internalName: internalName)
		
		return DeviceInfo(name: deviceName, communicatorInternalName: communicatorInternalName, offCommandInternalName: offCommandInternalName, onCommandInternalName: onCommandInternalName)
	}
	
	private func createQueryForRecordType(recordType: String) -> CKQuery {
		let predicate = NSPredicate(value: true)
		return CKQuery(recordType: "Device", predicate: predicate)
	}

}
