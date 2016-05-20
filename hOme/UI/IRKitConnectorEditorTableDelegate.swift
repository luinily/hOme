//
//  IRKitConnectorEditorTableDelegate.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitConnectorEditorTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	private let _sectionName = 0
	private let _sectionProperties = 1
	
	private let _rowBonjourName = 0
	private let _rowIP = 1
	
	private var _irKitConnector: IRKitConnector?
	
	func setConnector(connector: IRKitConnector) {
		_irKitConnector = connector
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == _sectionName {
			return 1
		} else if section == _sectionProperties {
			return 2
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		
		cell.textLabel?.text = getCellText(indexPath)
		setCellAccessory(cell, indexPath: indexPath)


		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	
		switch indexPath.section {
		case _sectionName:
			showNameEditView()
		case _sectionProperties:
			if indexPath.row == _rowBonjourName {
				showSelectBonjourNameView()
			}
		default: break
		}
	}
	
	private func getCellText(indexPath: NSIndexPath) -> String {
		switch indexPath.section {
		case _sectionName: return "Name"
		case _sectionProperties:
			switch indexPath.row {
			case _rowBonjourName : return "Bonjour Name"
			case _rowIP : return "IP Address"
			default: return ""
			}
		default: return ""
		}
	}
	
	private func setCellAccessory(cell: UITableViewCell, indexPath: NSIndexPath) {
		switch indexPath.section {
		case _sectionName:
			let label = UILabel()
			label.text = _irKitConnector?.name
			cell.accessoryView = label
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		case _sectionProperties:
			switch indexPath.row {
			case _rowBonjourName :
				let label = UILabel()
				label.text = _irKitConnector?.bonjourName
				cell.accessoryView = label
				cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
			case _rowIP :
				let label = UILabel()
				label.text = _irKitConnector?.ipAddress
				cell.accessoryView = label
				cell.accessoryType = UITableViewCellAccessoryType.None
			default:
				cell.accessoryType = UITableViewCellAccessoryType.None
			}
		default: return
		}
	}
	
	private func showNameEditView() {
		
	}
	
	private func showSelectBonjourNameView() {
		
	}
}
