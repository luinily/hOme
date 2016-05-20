//
//  TemperatureCondition.swift
//  IRKitApp
//
//  Created by Coldefy Yoann on 2016/02/03.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum ConditionType {
	case lower
	case equal
	case higher
}
struct TemperatureCondition: Condition {
	private let _temperature: Double
	private let _conditionType: ConditionType
	
	init (temperature: Double, conditionType: ConditionType) {
		_temperature = temperature
		_conditionType = conditionType
	}
	
	func isTrue(temperature: Double) -> Bool {
		switch _conditionType {
		case .lower: return temperature < _temperature
		case .equal: return temperature == _temperature
		case .higher: return temperature > _temperature
		}
	}
}

extension TemperatureCondition: Equatable {}

func == (lhs: TemperatureCondition, rhs: TemperatureCondition) -> Bool {
	return (lhs._conditionType == rhs._conditionType) && (lhs._temperature == rhs._temperature)
}
