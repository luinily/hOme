//
//  SequenceManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum SequenceManagerError: ErrorType {
    case NameAlreadyUsed
    case NoNameInCKRecord
    case DifferentNumberOfSequenceNamesAndSequenceRecordsNames
    case CouldNotFindRecord
}

class SequenceManager {
    
    private var _sequences: [String: Sequence]
	private var _currentCKRecordName: String?
	
    var sequencesNames: [String] {return _sequences.keys.sort()}
	var sequences: [Sequence] {
		return _sequences.values.sort() {
			(sequence1, sequence2) in
			return sequence1.name < sequence2.name
		}
	}
	
    var count: Int {return _sequences.count}
    
    init() {
        _sequences = [String : Sequence]()
    }
	
    func createSequence(name: String) -> Sequence {
		let newName = Name(name: name, internalName: createNewUniqueName())
		let newSequence = Sequence(name: newName)
		_sequences[newName.internalName] = newSequence
		updateCloudKit()
		return newSequence
		
    }
	
    func getSequenceOfInternalName(internalName: String) -> Sequence? {
        return _sequences[internalName]
    }
	
	func deleteSequence(sequence: Sequence) {
		_sequences.removeValueForKey(sequence.internalName)
		updateCloudKit()
		CloudKitHelper.sharedHelper.remove(sequence)
	}
}

//MARK: - Manager
extension SequenceManager: Manager {
	func getUniqueNameBase() -> String {
		return "Sequence"
	}
	
	func isNameUnique(name: String) -> Bool {
		return _sequences.indexForKey(name) == nil
	}
}

//MARK: - CloudKitObject
extension SequenceManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommandOfUniqueName: (uniqueName: String) -> CommandProtocol?) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let sequenceRecordNames = ckRecord["sequenceRecordNames"] as? [String] else {
			throw SequenceManagerError.NoNameInCKRecord
		}
		
		for recordName in sequenceRecordNames {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						let sequence = try Sequence(record: record, getCommand: getCommandOfUniqueName)
						if self._sequences.indexForKey(sequence.internalName) == nil {
							self._sequences[sequence.internalName] = sequence
						}
					}
				} catch {
					
				}
			}
		}
	}
	
	func getNewCKRecordName() -> String {
		return "SequenceManager"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "SequenceManager"
	}
	
	func setUpCKRecord(record: CKRecord) {
		var sequenceRecordNames = [String]()
		
		_sequences.forEach({
			(sequenceName, sequence) in
			sequenceRecordNames.append(sequence.getNewCKRecordName())
		})
		
		record["sequenceRecordNames"] = sequenceRecordNames
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
	// =========================================

}
