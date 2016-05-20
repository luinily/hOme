//
//  ButtonsTableDelegate.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

class ButtonsTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	private let _sectionButtons = 0
	private let _sectionNewButton = 1
	private var _showNewButtonView: (() -> Void)?
	private var _showButtonView: ((button: Button) -> Void)?
	private var _buttons = [Button]()
	
	func setShowButtonView(showButtonView: (button: Button) -> Void) {
		_showButtonView = showButtonView
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionButtons {
			return "Buttons"
		}
		return ""
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
		
		if let label = cell.textLabel {
			if indexPath.section == _sectionButtons {
				if let application = application {
					label.text = application.getButtons()[indexPath.row].name
				}
			} else if indexPath.section ==  _sectionNewButton {
				label.text = "Add New Button..."
			}
			
		}
		
		if indexPath.section == _sectionButtons {
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == _sectionButtons {
				_showButtonView?(button: _buttons[indexPath.row])
		} else if indexPath.section == _sectionNewButton {
			_showNewButtonView?()
			application?.createNewButton(ButtonType.flic, name: "button") {
				tableView.reloadData()
			}
		}
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .Destructive, title: "Delete") {
			action, indexPath in
			if let application = self.application {
				application.deleteButton(self._buttons[indexPath.row])
				tableView.reloadData()
			}
		}
		
		return [delete]
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return indexPath.section == _sectionButtons
	}
	
	private func setButtons(buttons: [Button]) {
		for button in _buttons {
			button.setOnPressForUI(nil)
		}
		_buttons = buttons
		for button in _buttons {
			button.setOnPressForUI(nil)
		}
	}
}

//MARK: - ApplicationUser
extension ButtonsTableDelegate: ApplicationUser {
	
}
