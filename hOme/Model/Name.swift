//
//  Name.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/04/11.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct Name {
	private var _name: String
	var name: String {
		get {return _name}
		set(name) {_name = name}
	}
	
	private var _internalName: String
	var internalName: String {return _internalName}
	
	init (name: String, internalName: String) {
		_name = name
		_internalName = internalName
	}
}

extension Name: Equatable {
	
}

func == (lhs: Name, rhs: Name) -> Bool {
	return (lhs.name == rhs.name) && (lhs.internalName == rhs.internalName)
}
