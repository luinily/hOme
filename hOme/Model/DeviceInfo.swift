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
	var name: Name
	var communicatorInternalName: String
	var offCommandInternalName: String
	var onCommandInternalName: String
	
	init(record: [String: Any]) throws {
		guard let name = record["Name"] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let internalName = record["internalName"] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let communicatorName = record["CommunicatorName"] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let onCommandName = record["OnCommand"] as? String else {
			throw ImportError.ErrorCouldNotFindElement
		}
		
		guard let offCommandName = record["OffCommand"] as? String else {
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
}

extension DeviceInfo: Equatable {}

func == (lhs: DeviceInfo, rhs: DeviceInfo) -> Bool {
	return (lhs.name == rhs.name) &&
		(lhs.communicatorInternalName == rhs.communicatorInternalName) &&
		(lhs.onCommandInternalName == rhs.onCommandInternalName) &&
		(lhs.offCommandInternalName == rhs.offCommandInternalName)
}
