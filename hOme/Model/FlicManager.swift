//
//  FlicManager.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class FlicManager: NSObject, InputProtocol, SCLFlicManagerDelegate {
	private let _appKey = "6f90a672-3a48-4d43-9070-d7f06ecd1704"
	private let _appSecret = "cfd3a24d-091f-414f-8f0e-978ee49e1712"
	private var _manager: SCLFlicManager?
	private var _onButtonGrabbed: ((button: Button) -> Void)?
	
	override init() {
		super.init()
		_manager = SCLFlicManager(delegate: self, appID: _appKey, appSecret: _appSecret, backgroundExecution: false, andRestoreState: true)
		print("known buttons: " + String(_manager?.knownButtons().count))
		_manager?.delegate = self
	}
	
	func deleteButton(button: FlicButton) {
		if let flic = button.button {
			_manager?.forgetButton(flic)
		}
	}
	
	func flicManager(manager: SCLFlicManager, didChangeBluetoothState state: SCLFlicManagerBluetoothState) {
		NSLog("FlicManager did change state..")
	}
	
	func setOnButtonGrabbed(onButtonGrabbed: (button: Button) -> Void) {
		_onButtonGrabbed = onButtonGrabbed
	}
	
	func getButtonOfIdentifier(identifier: NSUUID) -> SCLFlicButton? {
		return  _manager?.knownButtons()[identifier]
	}
	
	func getButtonFromURL(url: NSURL) -> SCLFlicButton? {
		do {
			return try _manager?.generateButtonFromURL(url)
		} catch {
			print(error)
			print("Could not get SCLFlicButton")
		}
		return nil
	}
	
	func handleOpenURL(url: NSURL) -> Bool {
		if let flicButton = getButtonFromURL(url) {
			print("known buttons: " + String(_manager?.knownButtons().count))
			let button = FlicButton(button: flicButton, url: url)
			_onButtonGrabbed?(button: button)
			return true
		}
		return false
	}
	
	func grabButton() {
		_manager?.requestButtonFromFlicAppWithCallback("hOme://button")
	}
	
	func flicManagerDidRestoreState(manager: SCLFlicManager) {
		print("known buttons after restoration: " + String(_manager?.knownButtons().count))
	}
}
