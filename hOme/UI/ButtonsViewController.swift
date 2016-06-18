//
//  ButtonsViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class ButtonsViewController: UITableViewController {
	@IBOutlet var table: UITableView!
	
	private var _tableDelegate = ButtonsTableDelegate()
	private var _selectedButton: Button?
	
	override func viewDidLoad() {
		table.delegate = _tableDelegate
		table.dataSource = _tableDelegate
		_tableDelegate.setShowButtonView(showButtonView)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if let viewController = segue.destinationViewController as? FlicButtonViewController {
			if let button = _selectedButton as? FlicButton {
				viewController.setButton(button)
			}
			viewController.setOnReturnToParent(reloadData)
		}
	}
	
	private func showButtonView(_ button: Button) {
		_selectedButton = button
		if button is FlicButton {
			performSegue(withIdentifier: "EditFlicButtonSegue", sender: self)
		}
	}
	
	private func reloadData() {
		table.reloadData()
	}
}
