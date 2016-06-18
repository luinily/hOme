//
//  CreateDeviceInteractor.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CreateDeviceInteractorInput {
	func fetchConnectors()
	func validateDoneButtonState(_ request: CreateDevice_ValidateDoneButtonState_Request)
	func createDevice(_ request: CreateDevice_CreateDevice_Request)
}

protocol CreateDeviceInteractorOutput {
	func presentConnectors(_ response: CreateDevice_GetConnectors_Response)
	func setDoneButtonState(_ response: CreateDevice_ValidateDoneButtonState_Response)
	func presentCouldCreateDevice(_ response: CreateDevice_CreateDevice_Response)
}

class CreateDeviceInteractor: CreateDeviceInteractorInput {
	var output: CreateDeviceInteractorOutput!
	var getConnectorsWorker = GetConnectorsWorker()
	var devicesWorker: DevicesWorker
	
	// MARK: Business logic
	init() {
		devicesWorker = DevicesWorker(deviceStore: DeviceCloudKitStore())
	}
	
	func fetchConnectors() {
		let response = makeResponseFromConnectors()
		output.presentConnectors(response)
	}
	
	private func makeResponseFromConnectors() -> CreateDevice_GetConnectors_Response {
		let getConnectorsWorker = GetConnectorsWorker()
		let connectorsTypes = getConnectorsWorker.getConnectorTypes()
		let connectorsByTypes = getConnectorsWorker.getConnectorsByType()
		
		// NOTE: Pass the result to the Presenter
		
		return CreateDevice_GetConnectors_Response(connectorsTypes: connectorsTypes, connectorsByType: connectorsByTypes)
	}
	
	func validateDoneButtonState(_ request: CreateDevice_ValidateDoneButtonState_Request) {
		if request.name.isEmpty || !request.connectorSelected {
			output.setDoneButtonState(CreateDevice_ValidateDoneButtonState_Response(doneButtonEnabled: false))
		} else {
			output.setDoneButtonState(CreateDevice_ValidateDoneButtonState_Response(doneButtonEnabled: true))
		}
		
	}
	
	func createDevice(_ request: CreateDevice_CreateDevice_Request) {
		 devicesWorker.createDevice(name: request.name, connectorInternalName: request.connectorInternalName) {
			(couldCreateDevice) in
			let response = CreateDevice_CreateDevice_Response(couldCreateDevice: couldCreateDevice)
			self.output.presentCouldCreateDevice(response)
		}
	}
	
}
