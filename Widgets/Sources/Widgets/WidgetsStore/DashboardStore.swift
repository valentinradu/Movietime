//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Combine
import Foundation
import Hako

typealias DashboardStore = Store<DashboardState, any DashboardEnvProtocol>
typealias DashboardMutation = Mutation<DashboardState, any DashboardEnvProtocol>

public protocol DashboardEnvProtocol {
    associatedtype MoviesEnv: MoviesEnvProtocol
    var identityReady: PassthroughSubject<Bool, Never> { get }
    func fetchMoviesEnv() async -> MoviesEnv
}

struct DashboardState: Equatable {
    var isMenuOpen: Bool = false
    var username: String = ""
}

extension MutationProtocol where Self == DashboardMutation {
    static var logout: DashboardMutation {
        Mutation { state in
            // Making sure state doesn't persis between different users
            state = .init()
            return SideEffect { env in
                env.identityReady.send(false)
                return .noop
            }
        }
    }

    static var toggleMenu: DashboardMutation {
        Mutation { state in
            state.isMenuOpen.toggle()
            return .noop
        }
    }
}
