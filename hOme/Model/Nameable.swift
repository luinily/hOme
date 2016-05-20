//
//  Nameable.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/07.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol Nameable {
	var name: String {get set}
	var fullName: String {get}
	
	var internalName: String {get}
	
}
