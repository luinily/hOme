//
//  CommandSelectorSequenceCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class CommandSelectorSequenceCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	
	private var _sequence: Sequence?
	private var _sequenceSelected: Bool = false
	
	var sequence: Sequence? {
		get {return _sequence}
		set(sequence) {
			_sequence = sequence
			label.text = sequence?.name
		}
	}
	
	var sequenceSelected: Bool {
		get {return _sequenceSelected}
		set(sequenceSelected) {
			_sequenceSelected = sequenceSelected
			if _sequenceSelected {
				accessoryType = UITableViewCellAccessoryType.Checkmark
			} else {
				accessoryType = UITableViewCellAccessoryType.None
			}
		}
	}
}
