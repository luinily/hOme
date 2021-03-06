//
//  FlicButton.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class FlicButton: NSObject, SCLFlicButtonDelegate, Nameable, Button, CloudKitObject {
	private var _button: SCLFlicButton?
	private let _actionTypes: Set<ButtonActionType> = [ButtonActionType.press, ButtonActionType.doublePress, ButtonActionType.longPress]
	private var _actions = [ButtonActionType: CommandProtocol]()
	private var _flicName: String = "flic"
	private var _name: String = "flic"
	private var _identifier: UUID?
	private var _onPressedForUI: (() -> Void)?
	
	private var _currentCKRecordName: String?
	
	var button: SCLFlicButton? {return _button}
	
	init(button: SCLFlicButton?) {
		let newButton = button != nil
		
		_button = button
		_identifier = button?.buttonIdentifier
		if let button = button {
			_name = button.name
			_flicName = button.name
			_identifier = button.buttonIdentifier
		}
		super.init()
		
		_button?.delegate = self
		_button?.triggerBehavior = SCLFlicButtonTriggerBehavior.clickAndDoubleClickAndHold
		_button?.connect()
		if newButton {
			updateCloudKit()
		}
	}
	
	class func getButtonType() -> ButtonType {
		return .flic
	}
	
	func printButtonState() {
		var connectionState = "Unkown"
		if let button = _button {
			switch button.connectionState {
			case .connected: connectionState = "Connected"
			case .connecting: connectionState = "Connecting"
			case .disconnected: connectionState = "Disconnected"
			case .disconnecting: connectionState = "Disconnected"
			}
		}
		print(name + " buttonConnectionState: " + connectionState)
	}
	
	func reconnectButton() {
		print("reconnect flic " + name)
		button?.connect()
		
	}
	
	func getAvailableActionTypes() -> Set<ButtonActionType> {
		return _actionTypes
	}
	
	func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
		print("button " + _name + " click")
		_onPressedForUI?()
		_actions[.press]?.execute()
	}
	
	func flicButton(_ button: SCLFlicButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print("button " + _name + " double click")
		_onPressedForUI?()
		_actions[.doublePress]?.execute()
	}
	
	func flicButton(_ button: SCLFlicButton, didReceiveButtonHold queued: Bool, age: Int) {
		print("button " + _name + " long click")
		_onPressedForUI?()
		_actions[.longPress]?.execute()
	}
	
	func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: Error?) {
//		var errorString = ""
//		if let error = error?.description {
//			errorString = error
//		}
//		print(name + " didDisconnectWithError: " + errorString)
		
		reconnectButton()
	}

	//MARK: - Nameable
	var name: String {
		get {return _name}
		set {
			_name = newValue
			updateCloudKit()
		}
	}
	
	private func nameSetter(_ name: String) {
		_name = name
	}
	var fullName: String {return _name}
	
	var internalName: String {return _flicName}

	//MARK: - Button
	func getButtonAction(actionType: ButtonActionType) -> CommandProtocol? {
		return _actions[actionType]
	}
	
	func setButtonAction(actionType: ButtonActionType, action: CommandProtocol?) {
		_actions[actionType] = action
		updateCloudKit()
	}
	
	func setOnPressForUI(onPress: (() -> Void)?) {
		_onPressedForUI = onPress
	}
	
	//MARK: - CloudKitObject
	
	convenience init (ckRecord: CKRecord, getCommandOfUniqueName: (_ uniqueName: String) -> CommandProtocol?, getButtonOfIdentifier: (_ identifier: UUID) -> SCLFlicButton?) throws {

		guard let name = ckRecord["name"] as? String else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		
		guard let flicName = ckRecord["flicName"] as? String else {
			throw CommandClassError.noDeviceNameInCKRecord
		}
		
		self.init(button: nil)
		_name = name
		_flicName = flicName
		
		if let pressAction = ckRecord["pressAction"] as? String {
			_actions[ButtonActionType.press] = getCommandOfUniqueName(pressAction)
		}
		
		if let doublePressAction = ckRecord["doublePressAction"] as? String {
			_actions[ButtonActionType.doublePress] = getCommandOfUniqueName(doublePressAction)
		}
		
		if let longPressAction = ckRecord["longPressAction"] as? String {
			_actions[ButtonActionType.longPress] = getCommandOfUniqueName(longPressAction)
		}
		
		if let identifier = ckRecord["identifier"] as? String {
			_identifier = UUID(uuidString: identifier)
		}
		_currentCKRecordName = ckRecord.recordID.recordName
		
		if let identifier = _identifier {
			_button = getButtonOfIdentifier(identifier)
			_button?.delegate = self
			_button?.triggerBehavior = SCLFlicButtonTriggerBehavior.clickAndDoubleClickAndHold
			_button?.connect()
			if _button != nil {
				print("Restored button " + _name)
			}
		}
	}
	
	
	func getNewCKRecordName () -> String {
		return "FlicButton:" + _flicName
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		record["type"] = FlicButton.getButtonType().rawValue as CKRecordValue?
		record["identifier"] = _identifier?.uuidString as CKRecordValue?

		
		var data = [String]()
		_actions.forEach {
			(actionType, command) in
				data.append(command.internalName)
		}
		record["name"] = _name as CKRecordValue?
		record["flicName"] = _flicName as CKRecordValue?
		
		record["pressAction"] = data[0] as CKRecordValue?
		record["doublePressAction"] = data[1] as CKRecordValue?
		record["longPressAction"] = data[2] as CKRecordValue?

		
	}
	
	func getCKRecordType() -> String {
		return "FlicButton"
	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
