//
//  CloudKitWrapper.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/02.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitWrapperProtocol {
	func fetchRecordsOfType(type: String, completionHandler: (records: [[String: Any]]) -> Void)
}

class CloudKitWrapper: CloudKitWrapperProtocol {
	private var _container: CKContainer
	private var _dataBase: CKDatabase
	
	init() {
		_container = CKContainer(identifier: "iCloud.com.YoannColdefy.IRKitApp")
		_dataBase = _container.privateCloudDatabase
	}
	
	func fetchRecordsOfType(type: String, completionHandler: (records: [[String: Any]]) -> Void) {
		let query = createQueryForRecordType(type)
		performQuery(query, completionHandler: completionHandler)
	}
	
	private func performQuery(query: CKQuery, completionHandler: (records: [[String: Any]]) -> Void) {
		_dataBase.performQuery(query, inZoneWithID: nil) {
			(records, error) in
			self.receivedRecordsFromCloudkit(records, error: error, completionHandler: completionHandler)
		}
	}
	
	private func receivedRecordsFromCloudkit(records: [CKRecord]?, error: NSError?, completionHandler: (records: [[String: Any]]) -> Void) {
		if let records = records {
			let dics = convertRecordsToDic(records)
			completionHandler(records: dics)
		} else {
			print(error)
			completionHandler(records: [])
		}
	}
	
	func convertRecordsToDic(records: [CKRecord]) -> [[String: Any]] {
		var result = [[String: Any]]()
		
		for record in records {
			result.append(convertRecordToDic(record))
		}
		return result
	}
	
	func convertRecordToDic(record: CKRecord) -> [String: Any] {
		var dic = [String: Any]()
		for key in record.allKeys() {
			dic[key] = record[key]
		}
		return dic
	}
	
	private func createQueryForRecordType(recordType: String) -> CKQuery {
		let predicate = NSPredicate(value: true)
		return CKQuery(recordType: "Device", predicate: predicate)
	}
}
