//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Foundation
import Hako
import SwiftUI

extension Store {
    func bind<Value>(_ keyPath: KeyPath<S, Value>,
                     to fn: @escaping (Value) -> Mutation<S, E>) -> Binding<Value> {
        Binding {
            self.state[keyPath: keyPath]
        } set: { newValue in
            self.dispatch(fn(newValue))
        }
    }
}
