//
//  DeviceInfo.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/06/03.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum ImportError: ErrorType {
	case ErrorCouldNotFindElement
}

struct DeviceInfo {
	private let nameKey = "Name"
	private let internalNameKey = "internalName"
	private let communicatorInternalNameKey = "CommunicatorName"
	private let onCommandInternalNameKey = "OnCommand"
	private let offCommadnInternalNameKey = "OffCommand"
	
	var name: Name
	var communicatorInternalName: String
	var offCommandInternalName: String
	var onCommandInternalName: String
	
	init(record: [String: Any]) throws {
		guard let name = record[nameKey] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let internalName = record[internalNameKey] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let communicatorName = record[communicatorInternalNameKey] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let onCommandName = record[onCommandInternalNameKey] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let offCommandName = record[offCommadnInternalNameKey] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		self.name = Name(name: name, internalName: internalName)
		communicatorInternalName = communicatorName
		offCommandInternalName = offCommandName
		onCommandInternalName = onCommandName
	}
	
	init(name: Name, communicatorInternalName: String, offCommandInternalName: String, onCommandInternalName: String) {
		self.name = name
		self.communicatorInternalName = communicatorInternalName
		self.offCommandInternalName = offCommandInternalName
		self.onCommandInternalName = onCommandInternalName
	}
	
	func toDictionary() -> [String: Any] {
		var dic = [String: Any]()

		dic[nameKey] = name.name
		dic[internalNameKey] = name.internalName
		dic[communicatorInternalNameKey] = communicatorInternalName
		dic[offCommadnInternalNameKey] = offCommandInternalName
		dic[onCommandInternalNameKey] = onCommandInternalName
		
		return dic
	}
}

extension DeviceInfo: Equatable {}

func == (lhs: DeviceInfo, rhs: DeviceInfo) -> Bool {
	return (lhs.name == rhs.name) &&
		(lhs.communicatorInternalName == rhs.communicatorInternalName) &&
		(lhs.onCommandInternalName == rhs.onCommandInternalName) &&
		(lhs.offCommandInternalName == rhs.offCommandInternalName)
}
