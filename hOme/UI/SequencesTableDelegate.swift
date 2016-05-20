//
//  SequencesTableDelegate.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/02/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class SequencesTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	private let _sectionSequences = 0
	private let _sectionNewSequence = 1
	
	
	
	
	
	private func getApplication() -> Application? {
		if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
			return appDelegate.homeApplication
		} else {
			return nil
		}
	}
}
