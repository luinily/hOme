//
//  FlicButtonViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/15.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class FlicButtonViewController: UITableViewController {
	private var _button: FlicButton?
	private var _onReturnToParent: (() -> Void)?
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var clickLabel: UILabel!
	@IBOutlet weak var doubleClickLabel: UILabel!
	@IBOutlet weak var holdLabel: UILabel!
	
	override func viewDidLoad() {
		reloadView()
		nameTextField.addTarget(self, action: #selector(nameDidChange), forControlEvents: .EditingDidEnd)
		nameTextField.becomeFirstResponder()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let button = _button else {
			return
		}
		
		if let viewController = segue.destinationViewController as? SelectCommandViewController {
			if segue.identifier == "SelectFlicClickCommandSegue" {
				viewController.setOnCommandSelected(onSelectClickAction)
				viewController.setSelectedCommand(button.getButtonAction(ButtonActionType.press))
			} else if segue.identifier == "SelectFlicDoubleClickCommandSegue" {
				viewController.setOnCommandSelected(onSelectDoubleClickAction)
				viewController.setSelectedCommand(button.getButtonAction(ButtonActionType.doublePress))
			} else if segue.identifier == "SelectFlicHoldCommandSegue" {
				viewController.setOnCommandSelected(onSelectHoldAction)
				viewController.setSelectedCommand(button.getButtonAction(ButtonActionType.longPress))
			}
			
		}
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		_onReturnToParent?()
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 2 {
			_button?.reconnectButton()
		}
	}
	func setButton(button: FlicButton) {
		_button = button
	}
	
	func setOnReturnToParent(onReturnToParent: () -> Void) {
		_onReturnToParent = onReturnToParent
	}
	
	private func showSelectCommandView(button: Button) {
		if button is FlicButton {
			performSegueWithIdentifier("EditFlicButtonSegue", sender: self)
		}
	}
	
	private func reloadView() {
		nameTextField.text = ""
		clickLabel.text = "None"
		doubleClickLabel.text = "None"
		holdLabel.text = "None"
		
		if let button = _button {
			nameTextField.text = button.name
			if let command = button.getButtonAction(ButtonActionType.press) {
				clickLabel.text = command.fullName
			}
			if let command = button.getButtonAction(ButtonActionType.doublePress) {
				doubleClickLabel.text = command.fullName
			}
			if let command = button.getButtonAction(ButtonActionType.longPress) {
				holdLabel.text = command.fullName
			}
		}
	}
	
	func nameDidChange(sender: UITextField) {
		if let name = sender.text {
			_button?.name = name
		}
	}
	
	private func onSelectClickAction(command: CommandProtocol?) {
		_button?.setButtonAction(ButtonActionType.press, action: command)
		reloadView()
	}
	
	private func onSelectDoubleClickAction(command: CommandProtocol?) {
		_button?.setButtonAction(ButtonActionType.doublePress, action: command)
		reloadView()
	}
	
	private func onSelectHoldAction(command: CommandProtocol?) {
		_button?.setButtonAction(ButtonActionType.longPress, action: command)
		reloadView()
	}
}
