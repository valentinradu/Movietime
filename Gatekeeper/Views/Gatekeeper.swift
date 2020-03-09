//
//  GatekeeperView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Modifiers
import Styles
import Remotes
import Combine
import Components


public struct GatekeeperView: View {
    @EnvironmentObject private var model: GatekeeperModel
    @Environment(\.keyboard) private var keyboard: Keyboard
    public init() {}
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    HStack {
                        Spacer(minLength: 20)
                        VStack {
                            Spacer(minLength: 20)
                            // poor man's switch...
                            if self.model.page == .login {
                                LoginView()
                            }
                            if self.model.page == .createAccount {
                                CreateAccountView()
                            }
                            if self.model.page == .forgotPassword {
                                ForgotPasswordView()
                            }
                            Spacer(minLength: 20)
                        }
                        .frame(
                            minWidth: 300,
                            maxWidth: 400,
                            minHeight: geometry.size.height - self.keyboard.height)
                        Spacer(minLength: 20)
                    }
                }
                .frame(maxHeight: geometry.size.height - self.keyboard.height)
                if self.model.isLoading {
                    Spinner()
                }
            }
            Spacer()
        }
        .textFieldStyle(UnderlinedTextFieldStyle())
        .buttonStyle(OutlinedFormButton())
        .font(.system(size: 20, weight: .light))
        .animation(
            .linear(duration: Double(keyboard.animationDuration)),
            value: keyboard.height)
    }
}


public class GatekeeperModel: ObservableObject {
    public init() {
        $page
            .sink { _ in
                self.registerError = nil
                self.loginError = nil
                self.recoverError = nil
            }
            .store(in: &cancellables)
    }
    public enum Page {
        case login
        case createAccount
        case forgotPassword
    }
    @Published var page: Page = .login
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstNewPassword: String = ""
    @Published var secondNewPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var registerError: LocalizedError? = nil
    @Published var loginError: LocalizedError? = nil
    @Published var recoverError: LocalizedError? = nil
    @Published public var user: User? = nil

    private var cancellables: Set<AnyCancellable> = []
    func register() {
        isLoading = true
        User.register(firstName: firstName, lastName: lastName, email: email, password: password)
            .receive(on: RunLoop.main)
            .map({Optional($0)})
            .catch({error -> Just<User?> in
                self.registerError = error
                return Just(nil)
            })
            .sink(receiveValue: { user in
                self.user = user
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func login() {
        isLoading = true
        User.login(email: email, password: password)
            .receive(on: RunLoop.main)
            .map({Optional($0)})
            .catch({error -> Just<User?> in
                self.loginError = error
                return Just(nil)
            })
            .sink(receiveValue: { user in
                self.user = user
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func recover() {
        isLoading = true
        User.recoverPassword(email: email)
            .receive(on: RunLoop.main)
            .catch({error -> Just<Void> in
                self.recoverError = error
                return Just(())
            })
            .sink(receiveValue: { _ in
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
}
