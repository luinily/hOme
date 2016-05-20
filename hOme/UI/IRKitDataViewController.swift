//
//  IRKitDataViewController.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class IRKitDataViewController: UIViewController {
	
	@IBOutlet weak var irkitText: UITextView!
	private var _irKitData: String = ""
	
	override func viewDidLoad() {
		reloadData()
	}
	
	func setIRKitData(data: String) {
		_irKitData = data
	}
	
	private func reloadData() {
		irkitText.text = _irKitData
	}
}
