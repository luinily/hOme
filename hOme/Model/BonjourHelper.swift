//
//  BonjourHelper.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/01/12.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

class BonjourHelper: NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
	
	//to find the IP
	private let _browser = NSNetServiceBrowser()
	private var _service = NSNetService()
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
	
	func findServicesOfType(serviceType: String, onServicesFound: (serviceNames: [String]) -> Void) {
		_searchIP = false
		_onServicesFound = onServicesFound
		_foundServiceNames.removeAll()
		_browser.searchForServicesOfType(serviceType, inDomain: _domain)
	}
	
	func searchIPOfServiceOfServiceType(serviceType: String, serviceName: String, onIPFound : (ipAddress: String) -> Void) {
		_searchIP = true
		_onIPFound = onIPFound
		_searchedServiceName = serviceName
		_browser.searchForServicesOfType(serviceType, inDomain: _domain)
	}
	
	func netServiceDidResolveAddress(sender: NSNetService) {
		//https://github.com/stakes/Frameless/blob/master/Frameless/FramerBonjour.swift
		if let addresses = sender.addresses {
			for address in addresses {
				let ptr = UnsafePointer<sockaddr_in>(address.bytes)
				var addr = ptr.memory.sin_addr
				let buf = UnsafeMutablePointer<Int8>.alloc(Int(INET6_ADDRSTRLEN))
				let family = ptr.memory.sin_family
				var ipc: UnsafePointer<Int8> = nil
				if family == __uint8_t(AF_INET) {
					ipc = inet_ntop(Int32(family), &addr, buf, __uint32_t(INET6_ADDRSTRLEN))
				}
				if let ipAddress = String.fromCString(ipc) {
					_onIPFound?(ipAddress: ipAddress)
					print("found IP: " + ipAddress + " [" + sender.name + "]")
				}
			}
		}
	}
	
	func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {
		if _searchIP {
			if let name = _searchedServiceName {
				if aNetService.name.caseInsensitiveCompare(name) == NSComparisonResult.OrderedSame {
					_service = aNetService
					_service.delegate = self
					_service.resolveWithTimeout(5.0)
				}
			}
		} else {
			_foundServiceNames.append(aNetService.name)
			if !moreComing {
				_onServicesFound?(serviceNames: _foundServiceNames)
			}
		}
		print("found Bonjour service: " + _service.name)
	}
}
