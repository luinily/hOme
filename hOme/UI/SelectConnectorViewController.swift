//
//  SelectConnectorViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/10.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import UIKit

class SelectConnectorViewController: UITableViewController {
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
	
	func setOnConnectorSelected(_ onConnectorSelected: (connector: Connector) -> Void) {
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
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let connectors = application?.getConnectors(type: _connectorType) {
			_connectors = connectors
		}
		
		return _connectors.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Connectors"
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunicatorCell") as? SelectConectorCell else {
			return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "NotFoundCell")
		}
		
		cell.connector = _connectors[(indexPath as NSIndexPath).row]
		
		if cell.connector?.name == _selectedConnector?.name {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}
}

//MARK - UITableViewDelegate
extension SelectConnectorViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? SelectConectorCell
		_selectedConnector = cell?.connector
		tableView.reloadData()
		dismiss(animated: true, completion: nil)
	}
}
