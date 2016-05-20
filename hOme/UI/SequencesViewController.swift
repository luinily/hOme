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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? SequenceCell,
			sequenceVC = segue.destinationViewController as? SequenceViewController {
			if let sequence = cell.sequence {
				sequenceVC.setSequence(sequence)
			}
		} else  if let viewController = segue.destinationViewController as? UINavigationController {
			if let newSequenceVC = viewController.visibleViewController as? NewSequenceViewController {
				newSequenceVC.setOnDone(reloadData)
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		reloadData()
	}
	
	private func ShowSequence(sequence: Sequence) {
		performSegueWithIdentifier("ShowSequenceSegue", sender: self)
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
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == _sectionSequences {
			return "Sequences"
		}
		return ""
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		if indexPath.section == _sectionSequences {
			cell = tableView.dequeueReusableCellWithIdentifier("SequenceCell")
			if let cell = cell as? SequenceCell,
				application = application {
				cell.setSequence(application.getSequences()[indexPath.row])
			}
		} else if indexPath.section == _sectionNewSequence {
			cell = tableView.dequeueReusableCellWithIdentifier("NewSequenceCell")
		}
		
		if let cell = cell {
			return cell
		} else {
			return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
		}
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return indexPath.section == _sectionSequences
	}
}

// MARK: Table Delegate
extension SequencesViewController {
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .Destructive, title: "Delete") {
			action, indexPath in
			if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SequenceCell,
				application = self.application {
				if let sequence = cell.sequence {
					application.deleteSequence(sequence)
					tableView.reloadData()
					}
				}
			}
		return [delete]
	}

}
