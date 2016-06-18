//
//  Communicator.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/02.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum ConnectorClassError: ErrorProtocol {
    case noNameInCKRecord
}

protocol Connector: Nameable {
	var connectorType: ConnectorType {
		get
	}
	
	func getCommandType() -> CommandType
}
