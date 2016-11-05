//
//  ButtonsTableDelegate.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class ButtonsTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	private let _sectionButtons = 0
	private let _sectionNewButton = 1
	private var _showNewButtonView: (() -> Void)?
	private var _showButtonView: ((_ button: Button) -> Void)?
	private var _buttons = [Button]()
	
	func setShowButtonView(_ showButtonView: @escaping (_ button: Button) -> Void) {
		_showButtonView = showButtonView
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionButtons {
			return "Buttons"
		}
		return ""
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == _sectionButtons {
			if let application = application {
				_buttons = application.getButtons()
				return _buttons.count
			}
		} else if section == _sectionNewButton {
			return 1
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
		
		if let label = cell.textLabel {
			if (indexPath as NSIndexPath).section == _sectionButtons {
				if let application = application {
					label.text = application.getButtons()[(indexPath as NSIndexPath).row].name
				}
			} else if (indexPath as NSIndexPath).section ==  _sectionNewButton {
				label.text = "Add New Button..."
			}
			
		}
		
		if (indexPath as NSIndexPath).section == _sectionButtons {
			cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == _sectionButtons {
				_showButtonView?(_buttons[(indexPath as NSIndexPath).row])
		} else if (indexPath as NSIndexPath).section == _sectionNewButton {
			_showNewButtonView?()
			application?.createNewButton(ButtonType.flic, name: "button") {
				tableView.reloadData()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application {
				application.deleteButton(self._buttons[(indexPath as NSIndexPath).row])
				tableView.reloadData()
			}
		}
		
		return [delete]
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return (indexPath as NSIndexPath).section == _sectionButtons
	}
	
	private func setButtons(_ buttons: [Button]) {
		for button in _buttons {
			button.setOnPressForUI(onPress: nil)
		}
		_buttons = buttons
		for button in _buttons {
			button.setOnPressForUI(onPress: nil)
		}
	}
}

//MARK: - ApplicationUser
extension ButtonsTableDelegate: ApplicationUser {
	
}
