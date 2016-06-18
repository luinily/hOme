//
//  CloudKitObject.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/05/21.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitObject {
	//each class implementing this protocol should
	//save each new instance imediately
	//save the instance each time it's saved values are changed
	func getNewCKRecordName() -> String
	func getCurrentCKRecordName() -> String?
	func getCKRecordType() -> String
	func setUpCKRecord(_ record: CKRecord)
	func updateCloudKit()
}
