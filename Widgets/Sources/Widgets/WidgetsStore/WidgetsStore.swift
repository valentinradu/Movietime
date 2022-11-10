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

public typealias WidgetsStore = Store<WidgetsState, any WidgetsEnvProtocol>
public typealias WidgetsMutation = Mutation<WidgetsState, any WidgetsEnvProtocol>

public struct WidgetsState: Equatable {
    var isLoggedIn: Bool = false

    public init() {}
}

public protocol WidgetsEnvProtocol {
    associatedtype GatekeeperEnv: GatekeeperEnvProtocol
    associatedtype DashboardEnv: DashboardEnvProtocol
    func fetchGatekeeperEnv() async -> GatekeeperEnv
    func fetchDashboardEnv() async -> DashboardEnv
    var identityReady: PassthroughSubject<Bool, Never> { get }
}

public extension MutationProtocol where Self == WidgetsMutation {
    static func updateIsLoggedIn(value: Bool) -> WidgetsMutation {
        Mutation { state in
            state.isLoggedIn = value
            return .noop
        }
    }
}
