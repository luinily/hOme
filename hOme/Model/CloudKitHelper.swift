//
//  CloudKitHelper.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/19.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit



protocol CloudKitDatabase {
	func save(_ record: CKRecord, completionHandler: (CKRecord?, Error?) -> Void)
	func fetch(withRecordID recordID: CKRecordID, completionHandler: (CKRecord?, Error?) -> Void)
	func delete(withRecordID recordID: CKRecordID, completionHandler: (CKRecordID?, Error?) -> Void)
}

extension CKDatabase: CloudKitDatabase {}

enum CloudKitActionType {
	case save
	case fetch
	case delete
}

typealias CloudKitCompletionHandler = (record: CKRecord?, error: Error?) -> Void
typealias DeleteCloudKitCompletionHandler = (recordID: CKRecordID?, error: Error?) -> Void
typealias CloudKitAction = (record: CKRecord?,
						    recordID: CKRecordID?,
							action: CloudKitActionType,
							completionHandler: CloudKitCompletionHandler?,
							deleteCloudKitCompletionHandler: DeleteCloudKitCompletionHandler?)


class CloudKitHelper {
    class var sharedHelper: CloudKitHelper {
        struct Static {
            static let instance = CloudKitHelper()
        }
        return Static.instance
    }
	
    private var _container: CKContainer
    private var _dataBase: CloudKitDatabase
	private var _actionsToPerform = [CloudKitAction]()
    private var _isWorking = false
	
	private var _workStarted: (() -> Void)?
	private var _workEnded: ((noError: Bool) -> Void)?
	
	var isWorking: Bool {return _isWorking}
	var startWork: (() -> Void)? {return _workStarted}

    init() {
        _container = CKContainer(identifier: "iCloud.com.YoannColdefy.IRKitApp")
        _dataBase = _container.privateCloudDatabase
    }
	
	init(database: CloudKitDatabase) {
		_container = CKContainer.default()
		_dataBase = database
	}
	
	func setWorkStarted(_ workStarted: () -> Void) {
		_workStarted = workStarted
	}
	
	func setWorkEnded(_ workEnded: ((noError: Bool) -> Void)?) {
		_workEnded = workEnded
	}
	
	func removeWorkEnded() {
		_workEnded = nil
	}
	
	func export(_ object: CloudKitObject) {
		if let recordOldName = object.getCurrentCKRecordName() {
			updateRecord(object, recordOldName: recordOldName)
		} else {
			exportNewRecord(object)
		}		
	}
	
	func importRecord(_ recordName: String, completionHandler: (record: CKRecord?) -> Void) {
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		action.action = CloudKitActionType.fetch
		action.recordID = CKRecordID(recordName : recordName)
		action.completionHandler = {
			(record, error) in
			if let error = error {
				completionHandler(record: nil)
				print("Fetch Error: " + recordName, terminator: "")
				print(error, terminator: "")
				self.continueWork()
			} else {
				if let record = record {
					completionHandler(record: record)
					print("Feched: " + record.recordID.recordName, terminator: "")
					self.continueWork()
				} else {
					self.endWorkWithError()
				}
			}
		}
		addNewAction(action)
	}
	
	func remove(_ object: CloudKitObject) {
		if let recordOldName = object.getCurrentCKRecordName() {
			var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
			action.action = CloudKitActionType.delete
			action.recordID = CKRecordID(recordName : recordOldName)
			action.deleteCloudKitCompletionHandler = {
				(recordID, error) in
				if let error = error {
					print("Delete Error: " + recordOldName, terminator: "")
					print(error, terminator: "")
					self.endWorkWithError()
				} else {
					print("Removed: " + recordOldName, terminator: "")
					self.continueWork()
				}
			}
			
			addNewAction(action)
		}
	}
	
	private func addNewAction(_ action: CloudKitAction) {
		self._actionsToPerform.append(action)
		if !self._isWorking {
			_workStarted?()
			self._isWorking = true
			self.doNextAction()
		}
	}
	
	private func endWorkWithoutError() {
		_isWorking = false
		_workEnded?(noError: true)
	}
	
	private func endWorkWithError() {
		_isWorking = false
		_workEnded?(noError: false)
	}
	
	private func continueWork() {
		self._actionsToPerform.removeFirst()
		self.doNextAction()
	}
	
	private func doNextAction() {
		if let action = _actionsToPerform.first {
			switch action.action {
			case .save:
				if let record = action.record, let completionHandler = action.completionHandler {
					_dataBase.save(record, completionHandler: completionHandler)				}
			case .fetch:
				if let recordID = action.recordID, let completionHandler = action.completionHandler {
					_dataBase.fetch(withRecordID: recordID, completionHandler: completionHandler)				}
			case .delete:
				if let recordID = action.recordID, let completionHandler = action.deleteCloudKitCompletionHandler {
					_dataBase.delete(withRecordID: recordID, completionHandler: completionHandler)
				}
			}
		} else {
			endWorkWithoutError()
		}
	}
	
	private func saveRecord(_ object: CloudKitObject, record: CKRecord) {
		object.setUpCKRecord(record)
		
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		action.action = CloudKitActionType.save
		action.record = record
		action.completionHandler = {
			(record, error) in
			if let error = error {
				print("Save Error: " + object.getNewCKRecordName(), terminator: "")
				print(error, terminator: "")
				self.endWorkWithError()
			} else {
				if let record = record {
					print("Saved: " + record.recordID.recordName, terminator: "")
				}
				self.continueWork()
			}
		}
		addNewAction(action)
	}
	
	private func exportNewRecord(_ object: CloudKitObject) {
		let recordID = CKRecordID(recordName : object.getNewCKRecordName())
		let record = CKRecord(recordType: object.getCKRecordType(), recordID: recordID)
		saveRecord(object, record: record)
	}

	private func updateRecord(_ object: CloudKitObject, recordOldName: String) {
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		
		if recordOldName != object.getNewCKRecordName() { //name changes
			action.action = CloudKitActionType.delete
			action.recordID = CKRecordID(recordName : recordOldName)
			action.deleteCloudKitCompletionHandler = {
				(recordID, error) in
				
				if let error = error {
					print("Update Error (Delete):" + recordOldName, terminator: "")
					print(error, terminator: "")
					self.endWorkWithError()
				} else {
					self.exportNewRecord(object) //exports as a new record with the new name
					if let recordID = recordID {
						print("Deleted: " + recordID.recordName, terminator: "")
					}
					self.continueWork()
				}
			}
		} else {
			action.action = CloudKitActionType.fetch
			action.recordID = CKRecordID(recordName : recordOldName)
			action.completionHandler = {
				(record, error) in
				if let error = error {
					print("Update Error (Fetch):" + object.getNewCKRecordName(), terminator: "")
					print(error, terminator: "")
					self.endWorkWithError()
				} else {
					if let record = record {
						self.saveRecord(object, record: record)
						print("Fetched: " + record.recordID.recordName, terminator: "")
						self.continueWork()
					} else {
						self.endWorkWithError()
					}
					
				}
			}
		}
		addNewAction(action)
	}
	
	
}
