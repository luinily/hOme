//
//  Button.swift
//  hOme
//
//  Created by Coldefy Yoann on 2016/03/08.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum ButtonActionType {
	case press
	case doublePress
	case longPress
}

protocol Button: Nameable, CloudKitObject {
	func getAvailableActionTypes() -> Set<ButtonActionType>
	func setButtonAction(actionType: ButtonActionType, action: CommandProtocol?)
	func setOnPressForUI(onPress: (() -> Void)?)
	
//	func getButtonType() -> ButtonType
}
