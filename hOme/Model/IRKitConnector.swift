//
//  IRKitConnector.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2015/11/29.
//  Copyright © 2015年 YoannColdefy. All rights reserved.
//

import Foundation
import Alamofire
import CloudKit



enum IRKitConnectorClassError: Error {
    case nameAldreadyExists
	case noBonjourName
}

final class IRKitConnector: NSObject, Nameable, Connector, CloudKitObject {
    static let bonjourServiceName = "_irkit._tcp."
	
	private var _name: String
	private var _ipAddress: String?
    private var _gotData = false
	private var _bonjourName: String
	private var _bonjourHelper: BonjourHelper?
	private var _dataToSend = Array<(data: IRKITSignal, completionHandler: (() -> Void)?)>()
	private var _sendingData = false
	
	private var _currentCKRecordName: String?

	var ipAddress: String? { return _ipAddress}
	var bonjourName: String? {return _bonjourName}

	init(name: Name) {
		_name = name.name
		_bonjourName = name.internalName
		_ipAddress = nil
		super.init()
		
		updateCloudKit()
		
	}
	
	init(ckRecordName: String, name: Name) {
		_name = name.name
		_bonjourName = name.internalName
		
		_ipAddress = nil
		super.init()
	}

	deinit {
		CloudKitHelper.sharedHelper.remove(self)
	}

	//MARK: data sending/reception
	func sendDataToIRKit(_ data: IRKITSignal, completionHandler: (() -> Void)?) {
		_dataToSend.append((data, completionHandler))
		if !_sendingData {
			_sendingData = true
			doSendData()
		}
	}

	func getDataFromIRKit(_ onComplete: @escaping (_ data: IRKITSignal) -> Void) {
		_gotData = false
		if let ipAddress = _ipAddress {
			let url = "http://" + ipAddress + "/messages"
			//headers: ["X-Requested-With": "curl"]
			_ = Alamofire.request(url).responseJSON {
					response in
					print("request : ")
					print(response.request.debugDescription)  // original URL request
					print("response : ")
					print(response.response.debugDescription) // URL response
					print("data : ")
					print(response.data.debugDescription)     // server data
					print("result : ")
					print(response.result)   // result of response serialization

					var data = IRKITSignal()
					data.setFromJSON(response.data)
					onComplete(data)

			}
		}
	}

    func getData(_ onComplete : @escaping (_ data: IRKITSignal) -> Void) {
        getDataFromIRKit(onComplete)
    }
	
	private func doSendData() {
		if let data = _dataToSend.first {
			_dataToSend.removeFirst()
			
			let json = data.data.getJSON()
			if let ipAddress = _ipAddress, let json = json {
				let url = "http://" + ipAddress + "/messages"
				_ = Alamofire.upload(json,
				                     to: url,
				                     method: .post,
				                     headers: ["X-Requested-With": "curl"]
					).responseJSON {
						response in
						print("Send IRkit Data")
						data.completionHandler?()
						if self._dataToSend.isEmpty {
							self._sendingData = false
						} else {
							self.doSendData()
						}
				}
			} else {
				_dataToSend.removeAll()
				self._sendingData = false
			}
		}
	
	}
	
	//MARK: IP
	private func findIPWithoutHandler() {
		findIP(completionHandler: {})
	}
	
	func findIP(completionHandler: @escaping () -> Void) {
		_bonjourHelper = nil //in case the ip has not be found the connector stays..
		_bonjourHelper = BonjourHelper()
		_bonjourHelper?.searchIPOfServiceOfServiceType(IRKitConnector.bonjourServiceName, serviceName: _bonjourName) {
			ipAddress in
			self._ipAddress = ipAddress
			self._bonjourHelper = nil //put it back to nil because it's safer not to reuse it
			completionHandler()
		}
	}

	// MARK: - Nameable
	var name: String {
		get {return _name}
		set {
			_name = newValue
			updateCloudKit()
		}
	}
	var fullName: String {return _bonjourName}
	
	var internalName: String {return _bonjourName}

	//MARK: - Connector
	var connectorType: ConnectorType {return ConnectorType.irKit}
	
	func getCommandType() -> CommandType {
		return IRKitCommand.getCommandType()
	}

	//MARK: - CloudKitObject
	convenience init(ckRecord: CKRecord) throws {
		self.init(ckRecordName: ckRecord.recordID.recordName, name: Name(name: "", internalName: ""))
		
		guard let name = ckRecord["Name"] as? String else {
			throw ConnectorClassError.noNameInCKRecord
		}
		
		guard let bonjourName = ckRecord["BonjourName"] as? String else {
			throw IRKitConnectorClassError.noBonjourName
		}
		
		_name = name
		_bonjourName = bonjourName
		DispatchQueue.main.async(execute: findIPWithoutHandler)
	}
	
	func getNewCKRecordName() -> String {
		return "IRKitConnector:" + internalName
	}
	
	func getCurrentCKRecordName() -> String? {
		return _currentCKRecordName
	}
	
	func getCKRecordType() -> String {
		return "IRKitConnector"
	}
	
	func setUpCKRecord(_ record: CKRecord) {
		record["ConnectorType"] = getCommandType().rawValue as CKRecordValue?
		record["Name"] = _name as CKRecordValue?
		record["BonjourName"] = _bonjourName as CKRecordValue?

	}
	
	func updateCloudKit() {
		CloudKitHelper.sharedHelper.export(self)
		_currentCKRecordName = getNewCKRecordName()
	}
}
