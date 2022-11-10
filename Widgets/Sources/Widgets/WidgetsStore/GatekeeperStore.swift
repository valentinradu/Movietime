//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Combine
import Foundation
import Hako
import Services

typealias GatekeeperStore = Store<GatekeeperState, any GatekeeperEnvProtocol>
typealias GatekeeperMutation = Mutation<GatekeeperState, any GatekeeperEnvProtocol>

public protocol GatekeeperEnvProtocol {
    associatedtype RemoteService: RemoteServiceProtocol
    var identityReady: PassthroughSubject<Bool, Never> { get }
    var remoteService: RemoteService { get }
}

struct GatekeeperState: Equatable {
    enum Page: Equatable {
        case login
        case createAccount
        case forgotPassword
    }

    var pages: [Page] = []
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var firstNewPassword: String = ""
    var secondNewPassword: String = ""
    var isLoading: Bool = false
    var registerError: String?
    var loginError: String?
    var recoverError: String?
    var recoverMessage: String?
}

extension MutationProtocol where Self == GatekeeperMutation {
    static func navigateTo(_ page: GatekeeperState.Page) -> GatekeeperMutation {
        Mutation { state in
            if page == .login {
                state.pages = []
            } else if let prevIndex = state.pages.firstIndex(of: page) {
                state.pages = Array(state.pages.prefix(through: prevIndex))
            } else {
                state.pages.append(page)
            }
            return .noop
        }
    }

    static var register: GatekeeperMutation {
        Mutation { state in
            // Here you'd normally validate all fields (once again - if you already did so in the update mutations)
            if state.firstNewPassword == state.secondNewPassword {
                state.isLoading = true
                return SideEffect { [state] env in
                    do {
                        try await env.remoteService.register(firstName: state.firstName,
                                                             lastName: state.lastName,
                                                             email: state.email,
                                                             password: state.firstNewPassword)
                        env.identityReady.send(true)
                        return Mutation { state in
                            state.isLoading = false
                            return .noop
                        }
                    } catch {
                        return Mutation { state in
                            state.registerError = error.localizedDescription
                            state.isLoading = false
                            return .noop
                        }
                    }
                }
            } else {
                state.registerError = "Password don't match"
                return .noop
            }
        }
    }

    static var login: GatekeeperMutation {
        Mutation { state in
            // Here you'd normally validate all fields (once again - if you already did so in the update mutations)
            state.isLoading = true
            return SideEffect { [state] env in
                do {
                    try await env.remoteService.login(email: state.email,
                                                      password: state.password)
                    env.identityReady.send(true)
                    return Mutation { state in
                        state.isLoading = false
                        return .noop
                    }
                } catch {
                    return Mutation { state in
                        state.loginError = error.localizedDescription
                        state.isLoading = false
                        return .noop
                    }
                }
            }
        }
    }

    static var forgotPassword: GatekeeperMutation {
        Mutation { state in
            state.isLoading = true
            return SideEffect { [state] env in
                do {
                    try await env.remoteService.forgotPassword(email: state.email)
                    return Mutation { state in
                        state.recoverMessage = "An email has been sent!"
                        state.isLoading = false
                        return .noop
                    }
                } catch {
                    return Mutation { state in
                        state.recoverError = error.localizedDescription
                        state.isLoading = false
                        return .noop
                    }
                }
            }
        }
    }

    static func updatePages(_ pages: [GatekeeperState.Page]) -> GatekeeperMutation {
        Mutation { state in
            state.pages = pages
            return .noop
        }
    }

    static func updateFirstName(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.firstName = value
            return .noop
        }
    }

    static func updateLastName(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.lastName = value
            return .noop
        }
    }

    static func updateEmail(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.email = value
            return .noop
        }
    }

    static func updatePassword(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.password = value
            return .noop
        }
    }

    static func updateFirstNewPassword(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.firstNewPassword = value
            return .noop
        }
    }

    static func updateSecondNewPassword(_ value: String) -> GatekeeperMutation {
        Mutation { state in
            // This is a great place validate the field before mutating the state
            state.secondNewPassword = value
            return .noop
        }
    }

    static var dismissAlert: GatekeeperMutation {
        Mutation { state in
            state.recoverMessage = nil
            return .noop
        }
    }
}
