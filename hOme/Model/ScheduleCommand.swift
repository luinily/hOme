//
//  ScheduleCommand.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/01/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class ScheduleCommand {
	private var _commandInternalName: String
	private var _time: (hour: Int, minute: Int) = (0, 0)
	private var _days = Set<Weekday>()
	private var _isOneTimeCommand = false
	private var _isActive = true
	private var _currentCKRecordName: String?
	private var _getCommand: (commandInternalName: String) -> CommandProtocol?
	var command: CommandProtocol? {
		get {return _getCommand(commandInternalName: _commandInternalName)}
	}
	var isActive: Bool {
		get {return _isActive}
		set {_isActive = newValue}
	}
	var days: Set<Weekday> {return _days}
	var hour: Int {return _time.hour}
	var minute: Int {return _time.minute}
	var timeString: String {return String(hour) + ":" + String(minute)}
	var isOneTimeCommand: Bool {return _isOneTimeCommand}
	
	init (commandInternalName: String, days: Set<Weekday>, time:(hour: Int, minute: Int), getCommand: (commandInternalName: String) -> CommandProtocol?) {
		_commandInternalName = commandInternalName
		_time = time
		_days = days
		_getCommand = getCommand
		
		updateCloudKit()
	}
	
	init (oneTimeCommandInternalName: String, day: Weekday, time: (hour: Int, minute: Int), getCommand: (commandInternalName: String) -> CommandProtocol?) {
		_commandInternalName = oneTimeCommandInternalName
		_time = time
		_days = [day]
		_getCommand = getCommand
		_isOneTimeCommand = true
	}
	
	func execute() {
		if _isActive {
			command?.execute()
			if _isOneTimeCommand {
				_isActive = false
			}
		}
	}
	
	private func setDays(_ days: [String]) {
		for day in days {
			if let day = stringToDay(day) {
				_days.formUnion([day])
			}
			
		}
	}
	
	private func stringToDay(_ day: String) -> Weekday? {
		switch day {
		case "Monday":
			return Weekday.monday
		case "Tuesday":
			return Weekday.tuesday
		case "Wednesday":
			return Weekday.wednesday
		case "Thursday":
			return Weekday.thursday
		case "Friday":
			return Weekday.friday
		case "Saturday":
			return Weekday.saturday
		case "Sunday":
			return Weekday.sunday
		default:
			print("weekday not found")
			return nil
		}
	}
	
	private func makeDaysStringArray() -> [String] {
		var result = [String]()
		if _days.contains(.monday) {
			result.append("Monday")
		}
		if _days.contains(.tuesday) {
			result.append("Tuesday")
		}
		if _days.contains(.wednesday) {
			result.append("Wednesday")
		}
		if _days.contains(.thursday) {
			result.append("Thursday")
		}
		if _days.contains(.friday) {
			result.append("Friday")
		}
		if _days.contains(.saturday) {
			result.append("Saturday")
		}
		if _days.contains(.sunday) {
			result.append("Sunday")
		}
		return result
	}
	
	func getCommand() -> CommandProtocol? {
		return _getCommand(commandInternalName: _commandInternalName)
	}
}

//MARK: - CloudKitObject
extension ScheduleCommand: CloudKitObject {
	convenience init (ckRecord: CKRecord, getCommand: (commandInternalName: String) -> CommandProtocol?) throws {
		self.init(oneTimeCommandInternalName: "", day: .monday, time: (hour: 0, minute: 0), getCommand: getCommand)
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let commandName = ckRecord["commandName"] as? String else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		guard let days = ckRecord["days"] as? [String] else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		guard let hour = ckRecord["hour"] as? Int else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		guard let minute = ckRecord["minute"] as? Int else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		
		self._commandInternalName = commandName
		self.setDays(days)
		self._time.hour = hour
		self._time.minute = minute
	}
	
	func getNewCKRecordName() -> String {
		if let command = command {
			return "ScheduleCommand:" + command.internalName + ":" + String(_time.hour) + ":" + String(_time.minute)
		} else {
			return ""
		}
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "ScheduleCommand"
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		record["commandName"] = _commandInternalName
		record["days"] = makeDaysStringArray()
		record["hour"] = _time.hour
		record["minute"] = _time.minute
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
