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
	func createRecordOfType(type: String, data: [String: Any], conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void)
	func deleteRecord(recordName: String, completionHandler: (couldDeleteRecord: Bool) -> Void)
	
}

enum CloudKitError: Error {
	case couldNotConvertToCKValueType
	case couldNotFindInternalName
	case recordAlreadyExisting
}

class CloudKitWrapper: CloudKitWrapperProtocol {
	private var _container: CKContainer
	private var _dataBase: CKDatabase
	
	init() {
		_container = CKContainer(identifier: "iCloud.com.YoannColdefy.IRKitApp")
		_dataBase = _container.privateCloudDatabase
	}
	
	func fetchRecordsOfType(type: String, completionHandler: (records: [[String: Any]]) -> Void) {
		let query = createQueryForRecordType(recordType: type)
		performQuery(query: query, completionHandler: completionHandler)
	}
	
	private func performQuery(query: CKQuery, completionHandler: (records: [[String: Any]]) -> Void) {
		_dataBase.perform(query, inZoneWith: nil) {
			(records, error) in
			self.receivedRecordsFromCloudkit(records: records, error: error, completionHandler: completionHandler)
		}
	}
	
	private func receivedRecordsFromCloudkit(records: [CKRecord]?, error: NSError?, completionHandler: (records: [[String: Any]]) -> Void) {
		if let records = records {
			let dics = convertRecordsToDic(records: records)
			completionHandler(records: dics)
		} else {
			print(error)
			completionHandler(records: [])
		}
	}
	
	
	func convertRecordsToDic(records: [CKRecord]) -> [[String: Any]] {
		var result = [[String: Any]]()
		
		for record in records {
			result.append(convertRecordToDic(record: record))
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
	
	func createRecordOfType(type: String, data: [String: Any], conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void) {
		do {
			let record = try convertDicToRecord(recordType: type, data: data)
			saveRecord(record: record, conpletionHandler: conpletionHandler)
		} catch {
			conpletionHandler(couldCreateDevice: false, error: nil)
		}
		
	}
	
	private func saveRecord(record: CKRecord, conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void) {
		_dataBase.save(record) {
			(record, error) in
			if let error = error {
				let cloudKitError = self.convertError(error: error)
				conpletionHandler(couldCreateDevice: false, error: cloudKitError)
			} else {
				conpletionHandler(couldCreateDevice: true, error: nil)
			}
		}
	}
	
	private func convertError(error: NSError) -> CloudKitError? {
		switch error.code {
		case CKError.Code.serverRecordChanged.rawValue: return CloudKitError.recordAlreadyExisting
		default: return nil
		}
	}
	
	func convertDicsToRecords(recordsType: String, data: [[String: Any]]) throws -> [CKRecord] {
		var records = [CKRecord]()
		for dic in data {
			let record = try convertDicToRecord(recordType: recordsType, data: dic)
			records.append(record)
		}
		return records
	}
	
	func convertDicToRecord(recordType: String, data: [String: Any]) throws -> CKRecord {
		let recordID = try makeRecordID(data: data)
		let record = CKRecord(recordType: recordType, recordID: recordID)
		for key in data.keys {
			if let value = data[key] as? CKRecordValue {
				record[key] =  value
			} else {
				throw CloudKitError.couldNotConvertToCKValueType
			}
		}
		return record
	}
	
	private func makeRecordID(data: [String: Any]) throws -> CKRecordID {
		if let name = data["internalName"] as? String {
			return makeRecordID(recordName: name)
		} else {
			throw CloudKitError.couldNotFindInternalName
		}
	}
	
	func deleteRecord(recordName: String, completionHandler: (couldDeleteRecord: Bool) -> Void) {
		let id = makeRecordID(recordName: recordName)
		_dataBase.delete(withRecordID: id) {
			deletedRecordID, error in
			completionHandler(couldDeleteRecord: deletedRecordID != nil)
		}
	}
	
	private func makeRecordID(recordName: String) -> CKRecordID {
		return CKRecordID(recordName: recordName)
	}
}
