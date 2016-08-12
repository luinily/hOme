//
//  CommunicatorManager.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/04.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum CommunicatorManagerClassError: Error {
    case noCommunicatorNamesInRecord
    case noCommunicatorRecordNamesInRecord
    case communicatorNamesAndRecordsNumberNotEqual
    case couldNotFindCommunicatorInCK
}



class ConnectorManager {
    private var _connectors: [String: Connector]
	private var _currentCKRecordName: String?
	
	var connectors: [Connector] {
			return _connectors.values.sorted() {
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
		return createConnector(type: type, name: name, internalName: internalName)
	}
	
	
    func deleteConnector(_ connector: Connector) {
		_connectors[connector.name] = nil
		updateCloudKit()
		if let connector = connector as? CloudKitObject {
			CloudKitHelper.sharedHelper.remove(connector)
		}
    }
	
	func getConnectorsTypes() -> [ConnectorType] {
		var connectorsTypes = [ConnectorType]()
		for connector in _connectors.values {
			if !connectorsTypes.contains(connector.connectorType) {
				connectorsTypes.append(connector.connectorType)
			}
		}
		return connectorsTypes
	}
	
	func getConnectorsByType() -> [ConnectorType: [Connector]] {
		var connectorsByType = [ConnectorType: [Connector]]()
		
		let connectorsTypes = getConnectorsTypes()
		for type in connectorsTypes {
			connectorsByType[type] = getConnectors(type: type)
		}
		
		return connectorsByType
	}
	
	func getConnectors(type: ConnectorType) -> [Connector] {
		return _connectors.values.filter() {
			connector in
			return connector.connectorType == type
		}
	}
	
    func getCommunicator(internalName: String) -> Connector? {
        return _connectors[internalName]
    }
}

extension ConnectorManager: Manager {
	func getUniqueNameBase() -> String {
		return "Connector"
	}
	
	func isNameUnique(_ name: String) -> Bool {
		return _connectors.index(forKey: name) == nil
	}
}

extension ConnectorManager: CloudKitObject {
	
	convenience init(ckRecord: CKRecord) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let connectorRecordsNames = ckRecord["communicatorRecordsNames"] as? [String] else {
			throw CommunicatorManagerClassError.noCommunicatorRecordNamesInRecord
		}
		
		for recordName in connectorRecordsNames {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						guard let connectorTypeRawValue = record["ConnectorType"] as? Int else {
							throw CommandManagerClassError.commandClassInvalid
						}
						
						guard let connectorType = ConnectorType(rawValue: connectorTypeRawValue) else {
							throw CommandManagerClassError.commandClassInvalid
						}
						
						let connector: Connector
						switch connectorType {
						case .irKit:
							connector = try IRKitConnector(ckRecord: record)
							
						}
						
						if self._connectors.index(forKey: connector.internalName) == nil {
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
	
	func setUpCKRecord(_ record: CKRecord) {
		var connectorRecordsNames = [String]()
		
		_connectors.forEach({
			(connectorName, connector) in
			if let connector = connector as? CloudKitObject {
				connectorRecordsNames.append(connector.getNewCKRecordName())
			}
		})
		
		record["communicatorRecordsNames"] = connectorRecordsNames
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
