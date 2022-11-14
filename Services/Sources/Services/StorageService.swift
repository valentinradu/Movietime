//
//  File.swift
//
//
//  Created by Valentin Radu on 12/11/2022.
//

import Foundation

public protocol StorageKey {
    associatedtype V
    static var defaultValue: V { get }
}

public struct StorageKeys {
    private var _values: [ObjectIdentifier: Any] = [:]
    public subscript<K>(_ key: K.Type) -> K.V where K: StorageKey {
        get {
            _values[ObjectIdentifier(key)] as? K.V ?? key.defaultValue
        }
        set {
            _values[ObjectIdentifier(key)] = newValue
        }
    }
}
