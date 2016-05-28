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
	func saveRecord(record: CKRecord, completionHandler: (CKRecord?, NSError?) -> Void)
	func fetchRecordWithID(recordID: CKRecordID, completionHandler: (CKRecord?, NSError?) -> Void)
	func deleteRecordWithID(recordID: CKRecordID, completionHandler: (CKRecordID?, NSError?) -> Void)
}

extension CKDatabase: CloudKitDatabase {}

enum CloudKitActionType {
	case save
	case fetch
	case delete
}

typealias CloudKitCompletionHandler = (record: CKRecord?, error: NSError?) -> Void
typealias DeleteCloudKitCompletionHandler = (recordID: CKRecordID?, error: NSError?) -> Void
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
		_container = CKContainer.defaultContainer()
		_dataBase = database
	}
	
	func setWorkStarted(workStarted: () -> Void) {
		_workStarted = workStarted
	}
	
	func setWorkEnded(workEnded: ((noError: Bool) -> Void)?) {
		_workEnded = workEnded
	}
	
	func removeWorkEnded() {
		_workEnded = nil
	}
	
	func export(object: CloudKitObject) {
		if let recordOldName = object.getCurrentCKRecordName() {
			updateRecord(object, recordOldName: recordOldName)
		} else {
			exportNewRecord(object)
		}		
	}
	
	func importRecord(recordName: String, completionHandler: (record: CKRecord?) -> Void) {
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		action.action = CloudKitActionType.fetch
		action.recordID = CKRecordID(recordName : recordName)
		action.completionHandler = {
			(record, error) in
			if let error = error {
				completionHandler(record: nil)
				print("Fetch Error: " + recordName)
				print(error)
				self.continueWork()
			} else {
				if let record = record {
					completionHandler(record: record)
					print("Feched: " + record.recordID.recordName)
					self.continueWork()
				} else {
					self.endWorkWithError()
				}
			}
		}
		addNewAction(action)
	}
	
	func remove(object: CloudKitObject) {
		if let recordOldName = object.getCurrentCKRecordName() {
			var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
			action.action = CloudKitActionType.delete
			action.recordID = CKRecordID(recordName : recordOldName)
			action.deleteCloudKitCompletionHandler = {
				(recordID, error) in
				if let error = error {
					print("Delete Error: " + recordOldName)
					print(error)
					self.endWorkWithError()
				} else {
					print("Removed: " + recordOldName)
					self.continueWork()
				}
			}
			
			addNewAction(action)
		}
	}
	
	private func addNewAction(action: CloudKitAction) {
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
				if let record = action.record, completionHandler = action.completionHandler {
					_dataBase.saveRecord(record, completionHandler: completionHandler)
				}
			case .fetch:
				if let recordID = action.recordID, completionHandler = action.completionHandler {
					_dataBase.fetchRecordWithID(recordID, completionHandler: completionHandler)
				}
			case .delete:
				if let recordID = action.recordID, completionHandler = action.deleteCloudKitCompletionHandler {
					_dataBase.deleteRecordWithID(recordID, completionHandler: completionHandler)
				}
			}
		} else {
			endWorkWithoutError()
		}
	}
	
	private func saveRecord(object: CloudKitObject, record: CKRecord) {
		object.setUpCKRecord(record)
		
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		action.action = CloudKitActionType.save
		action.record = record
		action.completionHandler = {
			(record, error) in
			if let error = error {
				print("Save Error: " + object.getNewCKRecordName())
				print(error)
				self.endWorkWithError()
			} else {
				if let record = record {
					print("Saved: " + record.recordID.recordName)
				}
				self.continueWork()
			}
		}
		addNewAction(action)
	}
	
	private func exportNewRecord(object: CloudKitObject) {
		let recordID = CKRecordID(recordName : object.getNewCKRecordName())
		let record = CKRecord(recordType: object.getCKRecordType(), recordID: recordID)
		saveRecord(object, record: record)
	}

	private func updateRecord(object: CloudKitObject, recordOldName: String) {
		var action = CloudKitAction(nil, nil, CloudKitActionType.fetch, nil, nil)
		
		if recordOldName != object.getNewCKRecordName() { //name changes
			action.action = CloudKitActionType.delete
			action.recordID = CKRecordID(recordName : recordOldName)
			action.deleteCloudKitCompletionHandler = {
				(recordID, error) in
				
				if let error = error {
					print("Update Error (Delete):" + recordOldName)
					print(error)
					self.endWorkWithError()
				} else {
					self.exportNewRecord(object) //exports as a new record with the new name
					if let recordID = recordID {
						print("Deleted: " + recordID.recordName)
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
					print("Update Error (Fetch):" + object.getNewCKRecordName())
					print(error)
					self.endWorkWithError()
				} else {
					if let record = record {
						self.saveRecord(object, record: record)
						print("Fetched: " + record.recordID.recordName)
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
