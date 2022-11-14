//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Combine
import Foundation
import Hako

public typealias DashboardCommand = Command<DashboardState>
typealias DashboardStore = Store<DashboardState>
typealias DashboardMutation = Mutation<DashboardState>

public struct DashboardState: Equatable {
    public var isMenuOpen: Bool = false
    public var username: String = ""
}

struct ToggleMenuMutation: Mutation {
    func reduce(state: inout DashboardState) -> DashboardCommand {
        state.isMenuOpen.toggle()
        return .noop
    }
}

struct LogOutMutation: Mutation {
    func reduce(state: inout DashboardState) -> DashboardCommand {
        state = .init()
        return .perform(UpdateIdentitySideEffect(isLoggedIn: false))
    }
}

struct UpdateIdentitySideEffect: SideEffect {
    let isLoggedIn: Bool
    func perform() async -> DashboardCommand {
        .noop
    }
}

public extension DashboardCommand {
    static var logout: DashboardCommand {
        .reduce(LogOutMutation())
    }

    static var toggleMenu: DashboardCommand {
        .reduce(ToggleMenuMutation())
    }
}
