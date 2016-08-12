//
//  SequenceManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum SequenceManagerError: Error {
    case nameAlreadyUsed
    case noNameInCKRecord
    case differentNumberOfSequenceNamesAndSequenceRecordsNames
    case couldNotFindRecord
}

class SequenceManager {
    
    private var _sequences: [String: Sequence]
	private var _currentCKRecordName: String?
	
    var sequencesNames: [String] {return _sequences.keys.sorted()}
	var sequences: [Sequence] {
		return _sequences.values.sorted() {
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
	
    func getSequence(internalName: String) -> Sequence? {
        return _sequences[internalName]
    }
	
	func deleteSequence(_ sequence: Sequence) {
		_sequences.removeValue(forKey: sequence.internalName)
		updateCloudKit()
		CloudKitHelper.sharedHelper.remove(sequence)
	}
}

//MARK: - Manager
extension SequenceManager: Manager {
	func getUniqueNameBase() -> String {
		return "Sequence"
	}
	
	func isNameUnique(_ name: String) -> Bool {
		return _sequences.index(forKey: name) == nil
	}
}

//MARK: - CloudKitObject
extension SequenceManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommandOfUniqueName: (uniqueName: String) -> CommandProtocol?) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let sequenceRecordNames = ckRecord["sequenceRecordNames"] as? [String] else {
			throw SequenceManagerError.noNameInCKRecord
		}
		
		for recordName in sequenceRecordNames {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						let sequence = try Sequence(record: record, getCommand: getCommandOfUniqueName)
						if self._sequences.index(forKey: sequence.internalName) == nil {
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
	
	func setUpCKRecord(_ record: CKRecord) {
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
