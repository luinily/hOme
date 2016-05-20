//
//  ButtonManager.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

enum ButtonType: Int {
	case flic = 1
}

class ButtonManager {
	private var _buttons = [String: Button]()
	private var _flicManager = FlicManager()
	
	private var _currentCKRecordName: String?
	private var _onNewFlic: (() -> Void)?
	
	var buttons: [Button] {
		return _buttons.values.sort() {
			(button1, button2) in
			return button1.name < button2.name
		}
	}
	
	var count: Int {return _buttons.count}
	
	init() {
		_flicManager.setOnButtonGrabbed(flicGrabbed)
	}
	
	func createNewButton(buttonType: ButtonType, name: String, completionHandler: () -> Void) {
		if buttonType == .flic {
			createNewFlic(completionHandler)
		}
	}
	
	func deleteButton(button: Button) {
		_buttons[button.internalName] = nil
	}
	
	func getButtonOfInternalName(internalName: String) -> Button? {
		return _buttons[internalName]
	}
	
	
	func handleOpenURL(url: NSURL) -> Bool {
		return _flicManager.handleOpenURL(url)
	}
}

//MARK - flic functions
extension ButtonManager {
	private func createNewFlic(completionHandler: () -> Void) {
		_onNewFlic = completionHandler
		_flicManager.grabButton()
	}

	private func flicGrabbed(flic: Button) {		
		if _buttons.indexForKey(flic.internalName) == nil {
			_buttons[flic.internalName] = flic
			_onNewFlic?()
			updateCloudKit()
		}
	}
}

//MARK: - CloudKitObject
extension ButtonManager: CloudKitObject {
	convenience init(ckRecord: CKRecord, getCommandOfUniqueName: (uniqueName: String) -> CommandProtocol?) throws {
		self.init()
		_currentCKRecordName = ckRecord.recordID.recordName
		
		if let buttonList = ckRecord["buttonData"] as? [String] {
			for recordName in buttonList {
				CloudKitHelper.sharedHelper.importRecord(recordName) {
					(record) in
					do {
						if let record = record {
							guard let buttonTypeRawValue = record["type"] as? Int else {
								throw CommandManagerClassError.CommandClassInvalid
							}
							
							guard let buttonType = ButtonType(rawValue: buttonTypeRawValue) else {
								throw CommandManagerClassError.CommandClassInvalid
							}
							
							var button: Button?
							
							switch buttonType {
							case .flic:
								button = try FlicButton(ckRecord: record, getCommandOfUniqueName: getCommandOfUniqueName, flicManager: self._flicManager)
							}
							
							if let button = button {
								self._buttons[button.internalName] = button
							}
							
							
						}
					} catch {
						
					}
				}
			}
		}
	}
	
	func getNewCKRecordName() -> String {
		return "ButtonManager"
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "ButtonManager"
	}
	
	func setUpCKRecord(record: CKRecord) {
		
		_currentCKRecordName = record.recordID.recordName
		
		var buttonList = [String]()
		
		for button in _buttons {
			buttonList.append(button.1.getNewCKRecordName())
		}
		
		if !buttonList.isEmpty {
			record["buttonData"] = buttonList
		}
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}

//MARK: - Manager
extension ButtonManager: Manager {
	func getUniqueNameBase() -> String {
		return "Button"
	}
	
	func isNameUnique(name: String) -> Bool {
		return _buttons.indexForKey(name) == nil
	}
}
