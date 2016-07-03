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
	
	@IBAction func cancel(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func done(_ sender: AnyObject) {
		_ = application?.createNewSequence(name: _name)
		_onDone?()
		self.dismiss(animated: true, completion: nil)
	}
	
	func setOnDone(_ onDone: () -> Void) {
		_onDone = onDone
	}
	
	private func onNameChanged(_ newName: String) {
		doneButton.isEnabled = newName != ""
	}
}

//MARK: - ApplicationUser
extension NewSequenceViewController: ApplicationUser {
	
}

//MARK: - Table Data Source
extension NewSequenceViewController {
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Name"
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "NewSequenceNameCell")
		if let cell = cell as? NameCell {
			cell.name = _name
			cell.setOnNameChanged(onNameChanged)
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
}
