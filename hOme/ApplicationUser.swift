//
//  ApplicationUser.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationUser {
	
}

extension ApplicationUser {
	var application: Application? {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			return appDelegate.homeApplication
		} else {
			return nil
		}
	}
}
