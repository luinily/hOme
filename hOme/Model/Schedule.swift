//
//  Squeduler.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum SquedulerClassError: ErrorType {
    case NoDataInckRecord
    case CouldNotFindSequence
}

enum Weekday: Int {
	case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

class Schedule {
	private var _commands = [ScheduleCommand]()
	
    private var _schedule = [Weekday: [Int: [Int: [ScheduleCommand]]]]()
	private var _currentCKRecordName: String?
	
	init() {
		_currentCKRecordName = nil
	}
	
	init(currentCKRecordName: String) {
		_currentCKRecordName = currentCKRecordName
	}
	
	func createAndAddNewScheduleCommand(command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int, getCommand: (commandInternalName: String) -> CommandProtocol?) -> ScheduleCommand {
		let newCommand = ScheduleCommand(commandInternalName: command.internalName, days: days, time: (hour, minute), getCommand: getCommand)
		_commands.append(newCommand)
		addCommandToSchedule(newCommand)
		updateCloudKit()
		
		return newCommand
    }
    
	func removeCommand(command: ScheduleCommand) {
		for day in command.days {
			removeCommandFromScheduleDay(day, command: command)
		}
		
		if let index = _commands.indexOf({$0 === command}) {
			_commands.removeAtIndex(index)
		}
		
		updateCloudKit()
    }
    
    func getCommandsForDay(day: Weekday) -> [ScheduleCommand] {
		var result = [ScheduleCommand]()
		for command in _commands {
			if command.days.contains(day) {
				result.append(command)
			}
		}
		
		return result.sort() {
			command1, command2 in
			if command1.hour == command2.hour {
				return command1.minute <= command2.minute
			} else {
				return command1.hour < command2.hour
			}
		}
    }
	
	func getSchedule() -> [Weekday: [ScheduleCommand]] {
		var result = [Weekday: [ScheduleCommand]]()
		
		result[.Monday] = getCommandsForDay(.Monday)
		result[.Tuesday] = getCommandsForDay(.Tuesday)
		result[.Wednesday] = getCommandsForDay(.Wednesday)
		result[.Thursday] = getCommandsForDay(.Thursday)
		result[.Friday] = getCommandsForDay(.Friday)
		result[.Saturday] = getCommandsForDay(.Saturday)
		result[.Sunday] = getCommandsForDay(.Sunday)
		
		return result
	}
	
	func getCommandsForMinute(day: Weekday, hour: Int, minute: Int) -> [ScheduleCommand]? {
		return _schedule[day]?[hour]?[minute]
	}
	
	private func addCommandToSchedule(command: ScheduleCommand) {
		for day in command.days {
			addToScheduleDay(day, command: command)
		}
	}
	
	private func updateSchedule() {
		_schedule.removeAll()
		for command in _commands {
			for day in command.days {
				addToScheduleDay(day, command: command)
			}
		}
	}
	
	private func addToScheduleDay(day: Weekday, command: ScheduleCommand) {
		if _schedule[day] == nil {
			_schedule[day] = [Int: [Int: [ScheduleCommand]]]()
		}
		
		if let dayCommands = _schedule[day] {
			if dayCommands[command.hour] == nil {
				_schedule[day]?[command.hour] = [Int: [ScheduleCommand]]()
			}
			
			if let hourCommands = _schedule[day]?[command.hour] {
				if hourCommands[command.minute] == nil {
					_schedule[day]?[command.hour]?[command.minute] = [ScheduleCommand]()
				}
				if let minuteCommands = _schedule[day]?[command.hour]?[command.minute] {
					if !minuteCommands.contains({$0 === command}) {
						_schedule[day]?[command.hour]?[command.minute]?.append(command)
					}
				}
			}
		}
	}
	
	private func removeCommandFromScheduleDay(day: Weekday, command: ScheduleCommand) {
		if var dayCommands = _schedule[day] {
			if var hourCommands = dayCommands[command.hour] {
				if var minuteCommands = hourCommands[command.minute] {
					if let index = minuteCommands.indexOf({$0 === command}) {
						minuteCommands.removeAtIndex(index)
						if minuteCommands.isEmpty {
							hourCommands[command.minute] = nil
							if hourCommands.isEmpty {
								dayCommands[command.hour] = nil
							}
						}
					}
				}
			}
		}
	}
	
}

extension Schedule: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommandOfUniqueName: (commandInternalName: String) -> CommandProtocol?) throws {
		self.init()
		
		_currentCKRecordName = ckRecord.recordID.recordName
		
		guard let commandList = ckRecord["commandRecordNames"] as? [String] else {
			throw SquedulerClassError.NoDataInckRecord
		}
		
		for recordName in commandList {
			CloudKitHelper.sharedHelper.importRecord(recordName) {
				(record) in
				do {
					if let record = record {
						let command = try ScheduleCommand.init(ckRecord : record, getCommand: getCommandOfUniqueName)
						self._commands.append(command)
						self.addCommandToSchedule(command)
					}
				} catch {
					
				}
			}
		}
	}
	
	func getNewCKRecordName() -> String {
		return "Schedule"
	}
	
	func getCKRecordType() -> String {
		return "Schedule"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func setUpCKRecord(record: CKRecord) {
		var commandRecordNames = [String]()
		for command in _commands {
			commandRecordNames.append(command.getNewCKRecordName())
		}
		record["commandRecordNames"] = commandRecordNames
		
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
