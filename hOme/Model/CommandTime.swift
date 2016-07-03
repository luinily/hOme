//
//  CommandTime.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/16.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum CommandTimeError: ErrorProtocol {
	case stringFormatInvalid

}

struct CommandTime {
	
	//add an init to be able to init with values
	//add set from string
	private var _hours: Int = 0
	var hours: Int {
		get {return _hours}
		set {
			_hours = ensureRange(value: newValue, min: 0, max: 23)
		}
	}
		
	private var _minutes: Int = 0
	var minutes: Int {
		get {return _minutes}
		set {
			_minutes = ensureRange(value: newValue, min: 0, max: 59)
		}
	}
	
	var time: String {
		get {
			var hours = String(_hours)
			if hours.characters.count == 1 {
				hours = "0" + hours
			}
			
			var minutes = String(_minutes)
			if minutes.characters.count == 1 {
				minutes = "0" + minutes
			}
				
			return hours + ":" + minutes
		}
		set {
			if let separationIndex = newValue.characters.index(of: ":") {
				let nextCharIndex = newValue.index(after: separationIndex)
				let hoursString = newValue.substring(to: separationIndex)
				if let newHours = Int(hoursString) {
					hours = newHours
				}
				
				let minutesString = newValue.substring(from: nextCharIndex)
				if let newMinutes = Int(minutesString) {
					minutes = newMinutes
				}
			
			} else {
//				throw CommandTimeError.StringFormatInvalid
			}
		}
	}
	
}
