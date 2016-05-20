//
//  IRKitDataCell.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/09.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitDataCell: UITableViewCell {
	private var _data = [Int]()
	
	var data: [Int] {
		get {return _data}
		set(data) {_data = data}
	}
}
