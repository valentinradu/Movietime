//
//  PropertyWrappers.swift
//  Modifiers
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Foundation

@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
