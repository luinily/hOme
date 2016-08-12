//
//  FlicManager.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/06.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

class FlicManager: NSObject {
	private let _appKey = "6f90a672-3a48-4d43-9070-d7f06ecd1704"
	private let _appSecret = "cfd3a24d-091f-414f-8f0e-978ee49e1712"
	private var _manager: SCLFlicManager?
	private var _onButtonGrabbed: ((button: Button) -> Void)?
	
	override init() {
		super.init()
		_manager = SCLFlicManager.configure(with: self, defaultButtonDelegate: nil, appID: _appKey, appSecret: _appSecret, backgroundExecution: false)
		print("known buttons: " + String(_manager?.knownButtons().count))
	}
	
	func deleteButton(_ button: FlicButton) {
		if let flic = button.button {
			_manager?.forget(flic)
		}
	}
	
	func setOnButtonGrabbed(_ onButtonGrabbed: (button: Button) -> Void) {
		_onButtonGrabbed = onButtonGrabbed
	}
	
	func getButton(identifier: UUID) -> SCLFlicButton? {
		return  _manager?.knownButtons()[identifier]
	}
	
	func grabButton() {
		_manager?.grabFlicFromFlicApp(withCallbackUrlScheme: "hOme://button")
	}
	
	func flicManagerDidRestoreState(_ manager: SCLFlicManager) {
		print("known buttons after restoration: " + String(_manager?.knownButtons().count))
	}
}

extension FlicManager: SCLFlicManagerDelegate {
	func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
		NSLog("FlicManager did change state..")
	}
	
	func flicManager(_ manager: SCLFlicManager, didGrab button: SCLFlicButton?, withError error: Error?) {
		let button = FlicButton(button: button)
		_onButtonGrabbed?(button: button)
	}
}
