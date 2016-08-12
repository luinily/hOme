//
//  BonjourHelper.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/01/12.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

class BonjourHelper: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
	
	//to find the IP
	private let _browser = NetServiceBrowser()
	private var _service = NetService()
	private var _searchedServiceName: String?
	private var _onIPFound: ((ipAddress: String) -> Void)?
	private var _onServicesFound: ((serviceNames: [String]) -> Void)?
	private var _searchIP = false
	private let _domain = "local."
	private var _foundServiceNames = [String]()
	
	override init() {
		super.init()
		_browser.delegate = self
	}
	
	func findServicesOfType(_ serviceType: String, onServicesFound: (serviceNames: [String]) -> Void) {
		_searchIP = false
		_onServicesFound = onServicesFound
		_foundServiceNames.removeAll()
		_browser.searchForServices(ofType: serviceType, inDomain: _domain)
	}
	
	func searchIPOfServiceOfServiceType(_ serviceType: String, serviceName: String, onIPFound : (ipAddress: String) -> Void) {
		_searchIP = true
		_onIPFound = onIPFound
		_searchedServiceName = serviceName
		_browser.searchForServices(ofType: serviceType, inDomain: _domain)
	}
	
	func netServiceDidResolveAddress(_ sender: NetService) {
		//https://github.com/stakes/Frameless/blob/master/Frameless/FramerBonjour.swift
		if let addresses = sender.addresses {
			for address in addresses {
				let ptr = UnsafePointer<sockaddr_in>((address as NSData).bytes)
				var addr = ptr.pointee.sin_addr
				let buf = UnsafeMutablePointer<Int8>.allocate(capacity: Int(INET6_ADDRSTRLEN))
				let family = ptr.pointee.sin_family
				var ipc: UnsafePointer<Int8>? = nil
				if family == __uint8_t(AF_INET) {
					ipc = inet_ntop(Int32(family), &addr, buf, __uint32_t(INET6_ADDRSTRLEN))
				}
				if let ipAddress = String(validatingUTF8: ipc!) {
					_onIPFound?(ipAddress: ipAddress)
					print("found IP: " + ipAddress + " [" + sender.name + "]", terminator: "")
				}
			}
		}
	}
	
	func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
		if _searchIP {
			if let name = _searchedServiceName {
				if aNetService.name.caseInsensitiveCompare(name) == ComparisonResult.orderedSame {
					_service = aNetService
					_service.delegate = self
					_service.resolve(withTimeout: 5.0)
				}
			}
		} else {
			_foundServiceNames.append(aNetService.name)
			if !moreComing {
				_onServicesFound?(serviceNames: _foundServiceNames)
			}
		}
		print("found Bonjour service: " + _service.name, terminator: "")
	}
}
