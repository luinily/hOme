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
		nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingDidEnd)
		nameTextField.becomeFirstResponder()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let button = _button else {
			return
		}
		
		if let viewController = segue.destinationViewController as? SelectCommandViewController {
			if segue.identifier == "SelectFlicClickCommandSegue" {
				viewController.setOnCommandSelected(onSelectClickAction)
				viewController.setSelectedCommand(button.getButtonAction(actionType: .press))
			} else if segue.identifier == "SelectFlicDoubleClickCommandSegue" {
				viewController.setOnCommandSelected(onSelectDoubleClickAction)
				viewController.setSelectedCommand(button.getButtonAction(actionType: .doublePress))
			} else if segue.identifier == "SelectFlicHoldCommandSegue" {
				viewController.setOnCommandSelected(onSelectHoldAction)
				viewController.setSelectedCommand(button.getButtonAction(actionType: .longPress))
			}
			
		}
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		_onReturnToParent?()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 2 {
			_button?.reconnectButton()
		}
	}
	func setButton(_ button: FlicButton) {
		_button = button
	}
	
	func setOnReturnToParent(_ onReturnToParent: () -> Void) {
		_onReturnToParent = onReturnToParent
	}
	
	private func showSelectCommandView(_ button: Button) {
		if button is FlicButton {
			performSegue(withIdentifier: "EditFlicButtonSegue", sender: self)
		}
	}
	
	private func reloadView() {
		nameTextField.text = ""
		clickLabel.text = "None"
		doubleClickLabel.text = "None"
		holdLabel.text = "None"
		
		if let button = _button {
			nameTextField.text = button.name
			if let command = button.getButtonAction(actionType: .press) {
				clickLabel.text = command.fullName
			}
			if let command = button.getButtonAction(actionType: .doublePress) {
				doubleClickLabel.text = command.fullName
			}
			if let command = button.getButtonAction(actionType: .longPress) {
				holdLabel.text = command.fullName
			}
		}
	}
	
	func nameDidChange(_ sender: UITextField) {
		if let name = sender.text {
			_button?.name = name
		}
	}
	
	private func onSelectClickAction(_ command: CommandProtocol?) {
		_button?.setButtonAction(actionType: .press, action: command)
		reloadView()
	}
	
	private func onSelectDoubleClickAction(_ command: CommandProtocol?) {
		_button?.setButtonAction(actionType: .doublePress, action: command)
		reloadView()
	}
	
	private func onSelectHoldAction(_ command: CommandProtocol?) {
		_button?.setButtonAction(actionType: .longPress, action: command)
		reloadView()
	}
}
