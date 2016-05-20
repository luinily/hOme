//
//  CommandProtocole.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/01/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol CommandProtocol: Nameable {	
	func execute()
}

extension CommandProtocol {
	func isEqualTo(other: CommandProtocol) -> Bool {
		if let other = other as? Self {
			return self.internalName == other.internalName
		} else {
			return false
		}
	}
}
