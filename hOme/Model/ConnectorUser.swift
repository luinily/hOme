//
//  ConnectorUser.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol ConnectorUser {
	func createAndAddNewConnector(type: ConnectorType, name: String, internalName: String) -> Connector?
	func createAndAddNewConnector(type: ConnectorType, name: String) -> Connector?
	func deleteConnector(connector: Connector)
	func getConnectorCount() -> Int
	func getConnectors() -> [Connector]
	func getConnectorsTypes() -> [ConnectorType]
	func getConnectorsByType() -> [ConnectorType: [Connector]]
	func getConnectorsOfType(type: ConnectorType) -> [Connector]
	func getConnectorOfInternalName(internalName: String) -> Connector?
}
