//
//  File.swift
//
//
//  Created by Valentin Radu on 14/11/2022.
//

import Foundation

public struct UserInput<V>: Equatable where V: Equatable, V: CustomStringConvertible {
    public enum Status: Equatable {
        case empty
        case valid
        case invalid
    }

    public var value: V {
        didSet {
            lastUpdate = .now
            if let regex {
                if value.description.wholeMatch(of: regex) == nil {
                    status = .invalid
                } else {
                    status = .valid
                }
            }
        }
    }

    public private(set) var lastUpdate: Date
    public private(set) var status: Status
    private let regex: Regex<AnyRegexOutput>?

    public init(_ initialValue: V, regex: Regex<AnyRegexOutput>?) {
        value = initialValue
        self.regex = regex
        status = .empty
        lastUpdate = .now
    }

    public static func == (lhs: UserInput<V>, rhs: UserInput<V>) -> Bool {
        lhs.value == rhs.value
    }
}
