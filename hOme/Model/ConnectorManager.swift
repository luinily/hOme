//
//  CommunicatorManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/04.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum CommunicatorManagerClassError: ErrorType {
    case NoCommunicatorNamesInRecord
    case NoCommunicatorRecordNamesInRecord
    case CommunicatorNamesAndRecordsNumberNotEqual
    case CouldNotFindCommunicatorInCK
}

enum ConnectorType: Int {
	case irKit = 1
}

class ConnectorManager {
    private var _connectors: [String: Connector]
	private var _currentCKRecordName: String?
	
	var connectors: [Connector] {
			return _connectors.values.sort() {
				(device1, device2) in
				return device1.name < device2.name
			}
	}
	
	var count: Int { return _connectors.count}
    
    init () {
        _connectors = [String: Connector]()
    }
    
	func createConnector(type: ConnectorType, name: String, internalName: String) -> Connector? {
		if isNameUnique(internalName) {
			var connector: Connector
			switch type {
			case .irKit: connector = IRKitConnector(name: Name(name: name, internalName: internalName))
			}
			
			_connectors[name] = connector
			
			updateCloudKit()
			return connector
		}
		return nil
	}
	
	func createConnector(type: ConnectorType, name: String) -> Connector? {
		let internalName = createNewUniqueName()
		return createConnector(type, name: name, internalName: internalName)
	}
	
	
    func deleteConnector(connector: Connector) {
		_connectors[connector.name] = nil
		updateCloudKit()
		CloudKitHelper.sharedHelper.remove(connector)
    }
	
	func getConnectorsOfType(type: ConnectorType) -> [Connector] {
		return _connectors.values.filter() {
			connector in
			return connector.connectorType == type
		}
	}
	
    func getCommunicatorOfUniqueName(uniqueName: String) -> Connector? {
        return _connectors[uniqueName]
    }
}

extension ConnectorManager: Manager {
	func getUniqueNameBase() -> String {
		return "Connector"
	}
	
	func isNameUnique(name: String) -> Bool {
		return _connectors.indexForKey(name) == nil
	}
}

extension ConnectorManager: CloudKitObject {
	
	convenience init(ckRecord: CKRecord) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let connectorRecordsNames = ckRecord["communicatorRecordsNames"] as? [String] else {
			throw CommunicatorManagerClassError.NoCommunicatorRecordNamesInRecord
		}
		
		for recordName in connectorRecordsNames {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						guard let connectorTypeRawValue = record["ConnectorType"] as? Int else {
							throw CommandManagerClassError.CommandClassInvalid
						}
						
						guard let connectorType = ConnectorType(rawValue: connectorTypeRawValue) else {
							throw CommandManagerClassError.CommandClassInvalid
						}
						
						let connector: Connector
						switch connectorType {
						case .irKit:
							connector = try IRKitConnector(ckRecord: record)
							
						}
						
						if self._connectors.indexForKey(connector.internalName) == nil {
							self._connectors[connector.internalName] = connector
							
						}
						
					}
				} catch {
					
				}
			}
		}
	}
	
	func getNewCKRecordName() -> String {
		return "CommunicatorManager"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "CommunicatorManager"
	}
	
	func setUpCKRecord(record: CKRecord) {
		var communicatorRecordsNames = [String]()
		
		_connectors.forEach({
			(communicatorName, communicator) in
			communicatorRecordsNames.append(communicator.getNewCKRecordName())
		})
		
		record["communicatorRecordsNames"] = communicatorRecordsNames
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
