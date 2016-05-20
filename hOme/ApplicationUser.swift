//
//  ApplicationUser.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol ApplicationUser {
	
}

extension ApplicationUser {
	var application: Application? {
		return getApplication()
	}
	
	private func getApplication() -> Application? {
		if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
			return appDelegate.homeApplication
		} else {
			return nil
		}
	}
}
