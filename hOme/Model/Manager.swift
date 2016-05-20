//
//  Manager.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/13.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol Manager {
	func getUniqueNameBase() -> String
	func isNameUnique(name: String) -> Bool
}

extension Manager {
	func createNewUniqueName() -> String {
		let nameBase = getUniqueNameBase()
		var nameAppendix = getNewNameAppendix()
		while !isNameUnique(nameBase + nameAppendix) {
			nameAppendix = getNewNameAppendix()
		}
		
		return nameBase + nameAppendix
	}
	
	private func getNewNameAppendix() -> String {
		return String(format: "%06X%06X", arc4random_uniform(UInt32(UInt16.max)), arc4random_uniform(UInt32(UInt16.max)))
	}
}
