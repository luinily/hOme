//
//  ConnectorsViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class ConnectorsViewController: UITableViewController {
	
	@IBOutlet weak var connectorsTable: UITableView!
	
	private let _sectionConnectors = 0
	private let _sectionNewConnector = 1
	
	private var _connectors = [Connector]()
	
	override func viewDidLoad() {

	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SelectConectorCell {
			if let connector = cell.connector as? IRKitConnector {
				if let viewController = segue.destinationViewController as? IRKitConnectorEditor {
					viewController.setConnector(connector)
				}
			}
		}
	}
}

//MARK: - ApplicationUser
extension ConnectorsViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension ConnectorsViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionConnectors {
			return "Connectors"
		}
		return ""
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		switch indexPath.section {
		case _sectionConnectors:
			cell = tableView.dequeueReusableCellWithIdentifier("ConnectorCell")
			if let cell = cell as? SelectConectorCell {
				cell.connector = _connectors[indexPath.row]
			}
		case _sectionNewConnector:
			cell = tableView.dequeueReusableCellWithIdentifier("NewConnectorCell")
		default:
			cell = nil
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .Destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application,
				cell = tableView.cellForRowAtIndexPath(indexPath) as? SelectConectorCell {
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
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}
}
