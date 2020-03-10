//
//  PropertyWrappers.swift
//  Modifiers
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import Foundation


@propertyWrapper
public struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
