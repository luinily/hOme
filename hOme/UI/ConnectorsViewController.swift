//
//  ConnectorsViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class ConnectorsViewController: UITableViewController, ApplicationUser {
	
	@IBOutlet weak var connectorsTable: UITableView!
	
	private let _sectionConnectors = 0
	private let _sectionNewConnector = 1
	
	private var _connectors = [Connector]()
	
	override func viewDidLoad() {

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? SelectConectorCell {
			if let connector = cell.connector as? IRKitConnector {
				if let viewController = segue.destination as? IRKitConnectorEditor {
					viewController.setConnector(connector)
				}
			}
		}
	}

	//MARK: - Table Data Source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionConnectors {
			return "Connectors"
		}
		return ""
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let application = application {
			switch section {
			case _sectionConnectors:
				_connectors = application.getConnectors()
				return _connectors.count
			case _sectionNewConnector:
				return 1
			default:
				return 0
			}
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		switch (indexPath as NSIndexPath).section {
		case _sectionConnectors:
			cell = tableView.dequeueReusableCell(withIdentifier: "ConnectorCell")
			if let cell = cell as? SelectConectorCell {
				cell.connector = _connectors[(indexPath as NSIndexPath).row]
			}
		case _sectionNewConnector:
			cell = tableView.dequeueReusableCell(withIdentifier: "NewConnectorCell")
		default:
			cell = nil
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application,
				let cell = tableView.cellForRow(at: indexPath) as? SelectConectorCell {
				if let connector = cell.connector {
					application.deleteConnector(connector)
					tableView.reloadData()
				}
			}
		}
		
		return [delete]
	}
}

//MARK: - Table Delegate
extension ConnectorsViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}
