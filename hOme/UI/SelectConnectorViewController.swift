//
//  SelectConnectorViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/10.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectConnectorViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	
	private var _selectedConnector: Connector?
	private var _parentReloadData: (() -> Void)?
	private var _connectorType: ConnectorType = .irKit
	private var _onConnectorSelected: ((connector: Connector) -> Void)?
	private var _connectors = [Connector]()
	
	var connectorType: ConnectorType {
		get {return _connectorType}
		set {_connectorType = newValue}
	}
	
	var selectedConnector: Connector? {
		get {return _selectedConnector}
		set {_selectedConnector = newValue}
	}
	
	override func viewDidLoad() {
	}
	
	func setOnConnectorSelected(onConnectorSelected: (connector: Connector) -> Void) {
		_onConnectorSelected = onConnectorSelected
	}
	
	private func getIRKitConnectors() -> [Connector] {
		if let application = application {
			let connectors = application.getConnectors()
			return connectors.flatMap() {
				(connector) in
				if connector is IRKitConnector {
					return connector
				}
				return nil
			}
			
		}
		
		return [IRKitConnector]()
	}
	
}

//MARK: - ApplicationUser
extension SelectConnectorViewController: ApplicationUser {
	
}

//MARK: - UITableViewDataSource
extension SelectConnectorViewController {
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let connectors = application?.getConnectorsOfType(_connectorType) {
			_connectors = connectors
		}
		
		return _connectors.count
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Connectors"
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier("CommunicatorCell") as? SelectConectorCell else {
			return UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "NotFoundCell")
		}
		
		cell.connector = _connectors[indexPath.row]
		
		if cell.connector?.name == _selectedConnector?.name {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
		return cell
	}
}

//MARK - UITableViewDelegate
extension SelectConnectorViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath) as? SelectConectorCell
		_selectedConnector = cell?.connector
		tableView.reloadData()
		dismissViewControllerAnimated(true, completion: nil)
	}
}
