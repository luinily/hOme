//
//  Sequence.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/12/01.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum SequenceClassError: ErrorType {
    case NoNameInRecord
    case NoCommandNames
    case RecordTimeInvalid
}
class Sequence: NSObject {
    private var _name: Name
    private var _commands = [Int: [CommandProtocol]]()
    private var _timer: NSTimer?
    private var _time: Int
    private var _maxTime: Int
	private var _currentCKRecordName: String? = nil
	
	init (name: Name) {
        _name = name
        _commands = [Int: [CommandProtocol]]()
        _time = 0
        _maxTime = 0
        super.init()
		
		updateCloudKit()
    }
	
	init (iCloudRecordName: String) {
		_currentCKRecordName = iCloudRecordName
		_name = Name(name: "", internalName: "")
		_time = 0
		_maxTime = 0
		super.init()
	}

	
    func addCommand(timeInMinutes: Int, command: CommandProtocol) {
		if _commands[timeInMinutes] == nil {
			_commands[timeInMinutes] = [CommandProtocol]()
		}
        _commands[timeInMinutes]?.append(command)
		_maxTime = max(_maxTime, timeInMinutes)
		
		updateCloudKit()
    }
	
	func getCommandCount() -> Int {
		return _commands.count
	}
	
	func getCommands() -> [(Int, [CommandProtocol])] {
		return _commands.sort() {
			(command1, command2) in
			return command1.0 < command2.0
		}
	}
	
    func clear() {
        _commands.removeAll()
        _maxTime = 0
		
		updateCloudKit()
    }
    
    private func updateMaxTime() {
        _maxTime = 0
        _commands.forEach({
			(time, command) in
			_maxTime = max(_maxTime, time)
		})
		
	}
	
	func removeCommand(time: Int, commandToRemove: CommandProtocol) {
		if let index = _commands[time]?.indexOf(({$0.isEqualTo(commandToRemove)})) {
			_commands[time]?.removeAtIndex(index)
			if let commands = _commands[time] {
				if commands.isEmpty {
					_commands[time] = nil
				}
			}
		}
	}
	
	func executeTaskForTimer(timer: NSTimer) {
		if let commands = _commands[_time] {
			for command in commands {
				command.execute()
			}
		}
		_time += 1
		if _time > _maxTime {
			timer.invalidate()
			_time = 0
		}
	}
}

//MARK: - Nameable
extension Sequence: Nameable {
	var name: String {
		get {return _name.name}
		set {
			_name.name = newValue
			updateCloudKit()
		}
	}
	var fullName: String {return "Sequence: " + _name.name}
	
	var internalName: String {return _name.internalName}
}

//MARK: - CommandProtocol
extension Sequence: CommandProtocol {
	func execute () {
		_time = 0
		_timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(Sequence.executeTaskForTimer(_:)), userInfo: nil, repeats: true)
		_timer?.fire()
		
	}
}

//MARK: - CloudKitObject
extension Sequence: CloudKitObject {
	convenience init (record: CKRecord, getCommand: (internalName: String) -> CommandProtocol?) throws {
		self.init(iCloudRecordName: record.recordID.recordName)
		
		guard let name = record["Name"] as? String else {
			throw SequenceClassError.NoNameInRecord
		}
		
		if let data = record["Data"] as? [String] {
			var time: Int? = nil
			for str in data {
				if time == nil {
					time = Int(str)
				} else {
					if let time = time {
						if _commands[time] == nil {
							_commands[time] = [CommandProtocol]()
						}
						
						if let command = getCommand(internalName: str) {
							_commands[time]?.append(command)
							
						}
					}
					time = nil
				}
			}

		}
		
		guard let internalName = record["InternalName"] as? String else {
			throw SequenceClassError.NoNameInRecord
		}
		
		_name = Name(name: name, internalName: internalName)
		
		
				updateMaxTime()
	}
	
	func getNewCKRecordName() -> String {
		return _name.internalName
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "SequenceClass"
	}
	
	func setUpCKRecord(record: CKRecord) {
		record["Name"] = _name.name
		record["InternalName"] = _name.internalName
		var data = [String]()
		_commands.forEach {
			(time, commands) in
			for command in commands {
				data.append(String(time))
				data.append(command.internalName)
			}
		}
		if data.count > 0 {
			record["Data"] = data
		}
	}
	
	func exportValues() {
		//nothing to do here
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}

}
