//
//  MathUtils.swift
//  temp
//
//  Created by Coldefy Yoann on 2016/05/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

public func ensureRange<T: Comparable>(_ value: T, min: T, max: T) -> T {
	if value < min {
		return min
	} else if value > max {
		return max
	} else {
		return value
	}
}
