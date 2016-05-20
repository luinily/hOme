//
//  SelectConectorCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/20.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SelectConectorCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	private var _connector: Connector? = nil
	
	var connector: Connector? {
		get {return _connector}
		set {
			_connector = newValue
			label.text = newValue?.name
		}
	}
	
}
