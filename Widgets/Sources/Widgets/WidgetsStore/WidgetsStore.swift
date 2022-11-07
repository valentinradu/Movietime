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

typealias Dispatch = (WidgetsMutation) -> Void

private struct DispatchEnvironmentKey: EnvironmentKey {
    @MainActor static var defaultValue: Dispatch = { _ in }
}

extension EnvironmentValues {
    var dispatch: Dispatch {
        get { self[DispatchEnvironmentKey.self] }
        set { self[DispatchEnvironmentKey.self] = newValue }
    }
}

@MainActor @propertyWrapper
struct PublishedMutation<Value: Equatable>: DynamicProperty {
    @Environment(\.dispatch) private var dispatch
    private let mutation: (Value) -> Mutation<WidgetsState, WidgetsEnv>
    private var value: Value

    init(wrappedValue: Value,
         _ mutation: @escaping (Value) -> Mutation<WidgetsState, WidgetsEnv>) {
        self.mutation = mutation
        value = wrappedValue
    }

    static subscript<EnclosingSelf>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value where EnclosingSelf: ObservableObject, EnclosingSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            let storage = instance[keyPath: storageKeyPath]
            return storage.value
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            guard newValue != storage.value else { return }
            instance.objectWillChange.send()
            storage.dispatch(storage.mutation(newValue))
        }
    }

//    static subscript<EnclosingSelf>(
//        _enclosingInstance instance: EnclosingSelf,
//        projected wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Binding<Value>>,
//        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
//    ) -> Binding<Value> {
//        Binding {
//            let storage = instance[keyPath: storageKeyPath]
//            return storage.value
//        } set: { newValue, _ in
//            instance.objectWillChange.send()
//            let storage = instance[keyPath: storageKeyPath]
//            storage.dispatch(storage.mutation(newValue))
//        }
//        fatalError()
//    }

    @available(*, unavailable,
               message: "@PublishedMutation can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    @available(*, unavailable,
               message: "@PublishedMutation can only be applied to classes")
    var projectedValue: Binding<Value> {
        get { fatalError() }
        set { fatalError() }
    }
}

typealias WidgetsStore = Store<WidgetsState, WidgetsEnv>
typealias WidgetsMutation = Mutation<WidgetsState, WidgetsEnv>

struct MovieLens: Hashable {
    let title: String
    let year: String
    let posterURL: URL
}

final struct GatekeeperState: Equatable {
    enum Page: Equatable {
        case login
        case createAccount
        case forgotPassword
    }

    var page: Page = .login
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var firstNewPassword: String = ""
    var secondNewPassword: String = ""
    var isLoading: Bool = false
    var registerError: String? = nil
    var loginError: String? = nil
    var recoverError: String? = nil
}

final class GatekeeperViewModel: Equatable, ObservableObject {
    enum Page: Equatable {
        case login
        case createAccount
        case forgotPassword
    }
    
    @PublishedMutation(WidgetsMutation.navigateTo) var page: Page = .login
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstNewPassword: String = ""
    @Published var secondNewPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var registerError: String? = nil
    @Published var loginError: String? = nil
    @Published var recoverError: String? = nil

    static func == (lhs: GatekeeperState, rhs: GatekeeperState) -> Bool {
        lhs.page == rhs.page
            && lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.email == rhs.email
            && lhs.password == rhs.password
            && lhs.firstNewPassword == rhs.firstNewPassword
            && lhs.secondNewPassword == rhs.secondNewPassword
            && lhs.isLoading == rhs.isLoading
            && lhs.registerError == rhs.registerError
            && lhs.loginError == rhs.loginError
            && lhs.recoverError == rhs.recoverError
    }
}

final class DashboardState: Equatable, ObservableObject {
    @Published var isMenuOpen: Bool = false
    @Published var username: String = ""

    static func == (lhs: DashboardState, rhs: DashboardState) -> Bool {
        lhs.isMenuOpen == rhs.isMenuOpen
            && lhs.username == rhs.username
    }
}

final class MoviesViewState: Equatable, ObservableObject {
    @Published var searchTerm: String = ""
    @Published var movies: [MovieLens] = []

    static func == (lhs: MoviesViewState, rhs: MoviesViewState) -> Bool {
        lhs.searchTerm == rhs.searchTerm
            && lhs.movies == rhs.movies
    }
}

final class WidgetsState: Equatable, ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var gatekeeperState: GatekeeperState? = nil
    @Published var moviesState: MoviesViewState? = nil
    @Published var dashboardState: DashboardState? = nil

    static func == (lhs: WidgetsState, rhs: WidgetsState) -> Bool {
        lhs.gatekeeperState == rhs.gatekeeperState
            && lhs.moviesState == rhs.moviesState
            && lhs.dashboardState == rhs.dashboardState
    }
}

protocol WidgetsEnv {}

struct WidgetsEnvMock: WidgetsEnv {}

extension MutationProtocol where Self == WidgetsMutation {
    static var logout: WidgetsMutation {
        Mutation { _ in
            .noop
        }
    }

    static var register: WidgetsMutation {
        Mutation { _ in
            .noop
        }
    }

    static func navigateTo(_ page: GatekeeperState.Page) -> WidgetsMutation {
        Mutation { _ in
            .noop
        }
    }
}
