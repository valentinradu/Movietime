//
//  File.swift
//
//
//  Created by Valentin Radu on 05/11/2022.
//

import Combine
import Foundation
import Hako
import SwiftUI

public typealias MainStore = Store<MainState, any MainEnvProtocol>
public typealias MainMutation = Mutation<MainState, any MainEnvProtocol>

public struct MainState: Equatable {
    var isLoggedIn: Bool = false

    public init() {}
}

public extension MutationProtocol where Self == MainMutation {
    static func updateIsLoggedIn(value: Bool) -> MainMutation {
        Mutation { state in
            state.isLoggedIn = value
            return .noop
        }
    }
}
