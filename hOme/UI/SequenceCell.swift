//
//  SequenceCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/04.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequenceCell: UITableViewCell {
	@IBOutlet weak var sequenceLabel: UILabel!
	
	private var _sequence: Sequence?
	
	var sequence: Sequence? {return _sequence}
	
	func setSequence(_ sequence: Sequence) {
		_sequence = sequence
		sequenceLabel.text = sequence.name
	}

}
