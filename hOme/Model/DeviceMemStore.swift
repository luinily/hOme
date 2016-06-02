//
//  DeviceMemStore.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/29.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

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

class DeviceCloudKitStore: DeviceStore {
	private var cloudKitWrapper: CloudKitWrapperProtocol
	
	init(cloudKitWrapper: CloudKitWrapperProtocol) {
		self.cloudKitWrapper = cloudKitWrapper
	}
	
	init() {
		self.cloudKitWrapper = CloudKitWrapper()
	}
	
	func fetchDevices(completionHandler: (devices: [DeviceInfo]) -> Void) {
		cloudKitWrapper.fetchRecordsOfType("Device") {
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

}
