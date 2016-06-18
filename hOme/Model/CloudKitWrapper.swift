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
	func fetchRecordsOfType(_ type: String, completionHandler: (records: [[String: Any]]) -> Void)
	func createRecordOfType(_ type: String, data: [String: Any], conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void)
}

enum CloudKitError: ErrorProtocol {
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
	
	func fetchRecordsOfType(_ type: String, completionHandler: (records: [[String: Any]]) -> Void) {
		let query = createQueryForRecordType(type)
		performQuery(query, completionHandler: completionHandler)
	}
	
	private func performQuery(_ query: CKQuery, completionHandler: (records: [[String: Any]]) -> Void) {
		_dataBase.perform(query, inZoneWith: nil) {
			(records, error) in
			self.receivedRecordsFromCloudkit(records, error: error, completionHandler: completionHandler)
		}
	}
	
	private func receivedRecordsFromCloudkit(_ records: [CKRecord]?, error: NSError?, completionHandler: (records: [[String: Any]]) -> Void) {
		if let records = records {
			let dics = convertRecordsToDic(records)
			completionHandler(records: dics)
		} else {
			print(error)
			completionHandler(records: [])
		}
	}
	
	
	func convertRecordsToDic(_ records: [CKRecord]) -> [[String: Any]] {
		var result = [[String: Any]]()
		
		for record in records {
			result.append(convertRecordToDic(record))
		}
		return result
	}
	
	func convertRecordToDic(_ record: CKRecord) -> [String: Any] {
		var dic = [String: Any]()
		for key in record.allKeys() {
			dic[key] = record[key]
		}
		return dic
	}
	
	private func createQueryForRecordType(_ recordType: String) -> CKQuery {
		let predicate = Predicate(value: true)
		return CKQuery(recordType: "Device", predicate: predicate)
	}
	
	func createRecordOfType(_ type: String, data: [String: Any], conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void) {
		do {
			let record = try convertDicToRecord(type, data: data)
			saveRecord(record, conpletionHandler: conpletionHandler)
		} catch {
			conpletionHandler(couldCreateDevice: false, error: nil)
		}
		
	}
	
	private func saveRecord(_ record: CKRecord, conpletionHandler: (couldCreateDevice: Bool, error: CloudKitError?) -> Void) {
		_dataBase.save(record) {
			(record, error) in
			if let error = error {
				let cloudKitError = self.convertError(error)
				conpletionHandler(couldCreateDevice: false, error: cloudKitError)
			} else {
				conpletionHandler(couldCreateDevice: true, error: nil)
			}
		}
	}
	
	private func convertError(_ error: NSError) -> CloudKitError? {
		switch error.code {
		case CKErrorCode.serverRecordChanged.rawValue: return CloudKitError.recordAlreadyExisting
		default: return nil
		}
	}
	
	func convertDicsToRecords(_ recordsType: String, data: [[String: Any]]) throws -> [CKRecord] {
		var records = [CKRecord]()
		for dic in data {
			let record = try convertDicToRecord(recordsType, data: dic)
			records.append(record)
		}
		return records
	}
	
	func convertDicToRecord(_ recordType: String, data: [String: Any]) throws -> CKRecord {
		let recordID = try makeRecordID(data)
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
	
	private func makeRecordID(_ data: [String: Any]) throws -> CKRecordID {
		if let name = data["internalName"] as? String {
			return CKRecordID(recordName: name)
		} else {
			throw CloudKitError.couldNotFindInternalName
		}
	}
	
}
