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
import Combine
import Components
import Model


public struct GatekeeperView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel
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
                            if self.viewModel.page == .login {
                                LoginView()
                            }
                            if self.viewModel.page == .createAccount {
                                CreateAccountView()
                            }
                            if self.viewModel.page == .forgotPassword {
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
                if self.viewModel.isLoading {
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

private var cancellables: Set<AnyCancellable> = []
public class GatekeeperViewModel: ObservableObject {
    private let model: Model
    public init(model: Model) {
        self.model = model
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

    
    func register() {
        isLoading = true
        model
            .register(firstName: firstName, lastName: lastName, email: email, password: password)
            .sink { [unowned self] error in
                self.isLoading = false
                self.registerError = error
            }
            .store(in: &cancellables)
    }

    func login() {
        isLoading = true
        model
            .login(email: email, password: password)
            .sink { [unowned self] error in
                self.isLoading = false
                self.loginError = error
            }
            .store(in: &cancellables)
    }

    func recover() {
        isLoading = true
        model
            .recoverPassword(email: email)
            .sink { [unowned self] error in
                self.isLoading = false
                self.recoverError = error
            }
            .store(in: &cancellables)
    }
}
