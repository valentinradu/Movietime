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

public typealias GatekeeperCommand = Command<GatekeeperState>

private extension UserInput where V == String {
    static var name: UserInput<String> {
        try! .init("", regex: Regex("^.{3,}$"))
    }

    static var email: UserInput<String> {
        try! .init("", regex: Regex("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"))
    }

    static var password: UserInput<String> {
        try! .init("", regex: Regex("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"))
    }
}

public struct GatekeeperState: Equatable {
    public enum Page: Equatable {
        case login
        case createAccount
        case forgotPassword
    }

    public var pages: [Page] = []
    public var firstName: UserInput<String> = .name
    public var lastName: UserInput<String> = .name
    public var email: UserInput<String> = .email
    public var password: UserInput<String> = .password
    public var firstNewPassword: UserInput<String> = .password
    public var secondNewPassword: UserInput<String> = .password
    public var isLoading: Bool = false
    public var errors: GatekeeperErrors = .init()
    public var recoverMessage: String?
}

public struct GatekeeperErrors: Equatable {
    public var loginError: String?
    public var recoverError: String?
    public var registerError: String?
}

struct NavigateToMutation: Mutation {
    let page: GatekeeperState.Page
    func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
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

struct UpdateLoadingMutation: Mutation {
    let isLoading: Bool
    func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
        state.isLoading = isLoading
        return .noop
    }
}

struct UpdateErrorMutation: Mutation {
    let keyPath: WritableKeyPath<GatekeeperErrors, String?>
    let value: String?

    func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
        state.errors[keyPath: keyPath] = value
        return .noop
    }
}

struct RegisterMutation: Mutation {
    func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
        // Here you'd normally validate all fields (once again - if you already did so in the update mutations)
        if state.firstNewPassword == state.secondNewPassword {
            return .dispatch(strategy: .serial,
                             commands: [
                                 .showLoadingIndicator,
                                 .hideLoadingIndicator
                             ])
        } else {
            return .updateRegisterError("Password don't match")
        }
    }
}

struct RegisterSideEffect: SideEffect {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    func perform() async -> GatekeeperCommand {
        do {
            try await Task.sleep(for: .seconds(1))
//            env.identityReady.send(true)
            return .noop
        } catch {
            return .updateRegisterError(error.localizedDescription)
        }
    }
}

struct LoginMutation: Mutation {
    func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
        // Here you'd normally validate all fields (once again - if you already did so in the update mutations)
        state.isLoading = true
        return .noop
    }
}

extension GatekeeperCommand {
    static var showLoadingIndicator: GatekeeperCommand {
        .reduce(UpdateLoadingMutation(isLoading: true))
    }

    static var hideLoadingIndicator: GatekeeperCommand {
        .reduce(UpdateLoadingMutation(isLoading: false))
    }

    static func updateRegisterError(_ value: String?) -> GatekeeperCommand {
        .reduce(UpdateErrorMutation(keyPath: \.registerError, value: value))
    }

    static func register(firstName: String,
                         lastName: String,
                         email: String,
                         password: String) -> GatekeeperCommand {
        .perform(RegisterSideEffect(firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    password: password))
    }
}

//        struct forgotPassword: Mutation {
//            func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
//                Mutation { state in
//                    state.isLoading = true
//                    retun .noop
//                }
//            }
//        }

//    return SideEffect { [state] env in
//        do {
//            try await env.remoteService.forgotPassword(email: state.email)
//            return Mutation { state in
//                state.recoverMessage = "An email has been sent!"
//                state.isLoading = false
//                return .noop
//            }
//        } catch {
//            return Mutation { state in
//                state.recoverError = error.localizedDescription
//                state.isLoading = false
//                return .noop
//            }
//        }
//    }

// SideEffect { [state] env in
//    do {
//        try await env.remoteService.login(email: state.email,
//                                          password: state.password)
//        env.identityReady.send(true)
//        return Mutation { state in
//            state.isLoading = false
//            return .noop
//        }
//    } catch {
//        return Mutation { state in
//            state.loginError = error.localizedDescription
//            state.isLoading = false
//            return .noop
//        }
//    }
// }

//        static func updatePages(_ pages: [GatekeeperState.Page]) -> Mutation {
//            func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
//                Mutation { state in
//                    state.pages = pages
//                    return .noop
//                }
//            }
//        }
//
//        struct dismissAlert: Mutation {
//            func reduce(state: inout GatekeeperState) -> GatekeeperCommand {
//                Mutation { state in
//                    state.recoverMessage = nil
//                    return .noop
//                }
//            }
//        }
