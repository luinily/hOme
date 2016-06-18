//
//  Squeduler.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/06.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum SquedulerClassError: ErrorProtocol {
    case noDataInckRecord
    case couldNotFindSequence
}

enum Weekday: Int {
	case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
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
	
	func createAndAddNewScheduleCommand(_ command: CommandProtocol, days: Set<Weekday>, hour: Int, minute: Int, getCommand: (commandInternalName: String) -> CommandProtocol?) -> ScheduleCommand {
		let newCommand = ScheduleCommand(commandInternalName: command.internalName, days: days, time: (hour, minute), getCommand: getCommand)
		_commands.append(newCommand)
		addCommandToSchedule(newCommand)
		updateCloudKit()
		
		return newCommand
    }
    
	func removeCommand(_ command: ScheduleCommand) {
		for day in command.days {
			removeCommandFromSchedule(day: day, command: command)
		}
		
		if let index = _commands.index(where: {$0 === command}) {
			_commands.remove(at: index)
		}
		
		updateCloudKit()
    }
    
    func getCommands(day: Weekday) -> [ScheduleCommand] {
		var result = [ScheduleCommand]()
		for command in _commands {
			if command.days.contains(day) {
				result.append(command)
			}
		}
		
		return result.sorted() {
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
		
		result[.monday] = getCommands(day: .monday)
		result[.tuesday] = getCommands(day: .tuesday)
		result[.wednesday] = getCommands(day: .wednesday)
		result[.thursday] = getCommands(day: .thursday)
		result[.friday] = getCommands(day: .friday)
		result[.saturday] = getCommands(day: .saturday)
		result[.sunday] = getCommands(day: .sunday)
		
		return result
	}
	
	func getCommands(day: Weekday, hour: Int, minute: Int) -> [ScheduleCommand]? {
		return _schedule[day]?[hour]?[minute]
	}
	
	private func addCommandToSchedule(_ command: ScheduleCommand) {
		for day in command.days {
			addToSchedule(day: day, command: command)
		}
	}
	
	private func updateSchedule() {
		_schedule.removeAll()
		for command in _commands {
			for day in command.days {
				addToSchedule(day: day, command: command)
			}
		}
	}
	
	private func addToSchedule(day: Weekday, command: ScheduleCommand) {
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
	
	private func removeCommandFromSchedule(day: Weekday, command: ScheduleCommand) {
		if var dayCommands = _schedule[day] {
			if var hourCommands = dayCommands[command.hour] {
				if var minuteCommands = hourCommands[command.minute] {
					if let index = minuteCommands.index(where: {$0 === command}) {
						minuteCommands.remove(at: index)
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
			throw SquedulerClassError.noDataInckRecord
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
	
	func setUpCKRecord(_ record: CKRecord) {
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
