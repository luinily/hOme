//
//  SequencesViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequencesViewController: UITableViewController {
	
	@IBOutlet weak var sequencesTable: UITableView!
	
	private let _sectionSequences = 0
	private let _sectionNewSequence = 1
	
	override func viewDidLoad() {
		sequencesTable.delegate = self
		sequencesTable.dataSource = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SequenceCell,
			let sequenceVC = segue.destination as? SequenceViewController {
			if let sequence = cell.sequence {
				sequenceVC.setSequence(sequence)
			}
		} else if let viewController = segue.destination as? UINavigationController {
			if let newSequenceVC = viewController.visibleViewController as? NewSequenceViewController {
				newSequenceVC.setOnDone(reloadData)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		reloadData()
	}
	
	private func ShowSequence(_ sequence: Sequence) {
		performSegue(withIdentifier: "ShowSequenceSegue", sender: self)
	}
	
	private func reloadData() {
		sequencesTable.reloadData()
	}

}

//MARK: - ApplicationUser
extension SequencesViewController: ApplicationUser {
	
}

//MARK: Table Data Source
extension SequencesViewController {
	
	//MARK: Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionSequences {
			return "Sequences"
		}
		return ""
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == _sectionSequences {
			if let application = application {
				return application.getSequenceCount()
			}
		} else if section == _sectionNewSequence {
			return 1
		}
		return 0
	}
	
	//MARK: Cells
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		if (indexPath as NSIndexPath).section == _sectionSequences {
			cell = tableView.dequeueReusableCell(withIdentifier: "SequenceCell")
			if let cell = cell as? SequenceCell,
				let application = application {
				cell.setSequence(application.getSequences()[(indexPath as NSIndexPath).row])
			}
		} else if (indexPath as NSIndexPath).section == _sectionNewSequence {
			cell = tableView.dequeueReusableCell(withIdentifier: "NewSequenceCell")
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return (indexPath as NSIndexPath).section == _sectionSequences
	}
}

// MARK: Table Delegate
extension SequencesViewController {
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
			action, indexPath in
			if let cell = tableView.cellForRow(at: indexPath) as? SequenceCell,
				let application = self.application {
				if let sequence = cell.sequence {
					application.deleteSequence(sequence)
					tableView.reloadData()
					}
				}
			}
		return [delete]
	}

}
