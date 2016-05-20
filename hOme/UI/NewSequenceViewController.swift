//
//  NewSequenceViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class NewSequenceViewController: UITableViewController {
	private var _name: String = "New Sequence"
	private var _onDone: (() -> Void)?
	
	var name: String {
		get {return _name}
		set {_name = newValue}
	}
	
	
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	@IBAction func cancel(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	@IBAction func done(sender: AnyObject) {
		application?.createNewSequence(_name)
		_onDone?()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func setOnDone(onDone: () -> Void) {
		_onDone = onDone
	}
	
	private func onNameChanged(newName: String) {
		doneButton.enabled = newName != ""
	}
}

//MARK: - ApplicationUser
extension NewSequenceViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension NewSequenceViewController {
	//MARK: Sections
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Name"
	}
	
	//MARK: Cells
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("NewSequenceNameCell")
		if let cell = cell as? NameCell {
			cell.name = _name
			cell.setOnNameChanged(onNameChanged)
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
}
