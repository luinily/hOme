//
//  IRKitSignal.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/02/03.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct IRKITSignal {
	var format = ""
	var frequence: Int = 0
	var data = [Int]()
	
	func hasSignal() -> Bool {
		return format != ""
	}
	
	mutating func setFromJSON(_ jsonData: Foundation.Data?) {
		if let jsonData = jsonData {
			let jsonObject: AnyObject!
			do {
				jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
				
				if let jsonObject = jsonObject {
					if let jsonDictionnary = jsonObject as? NSDictionary {
						if let data = jsonDictionnary["data"] as? [Int] {
							self.data = data
						}
						if let frequence = jsonDictionnary["freq"] as? Int {
							self.frequence = frequence
						}
						if let format = jsonDictionnary["format"] as? String {
							self.format = format
						}
					}
				}
			} catch {
				
			}
		}
	}
	
	func getJSON() -> Foundation.Data? {
		var jsonDictionnary = [String: AnyObject]()
		
		jsonDictionnary["format"] = format
		jsonDictionnary["freq"] = frequence
		jsonDictionnary["data"] = data
		
		do {
			return try JSONSerialization.data(withJSONObject: jsonDictionnary, options: [])
		} catch {
			print("could not make json")
			return nil
		}
	}
}

extension IRKITSignal: Equatable {}

func == (lhs: IRKITSignal, rhs: IRKITSignal) -> Bool {
	return (lhs.format == rhs.format)
		&& (lhs.frequence == rhs.frequence)
		&& (lhs.data == rhs.data)
}
