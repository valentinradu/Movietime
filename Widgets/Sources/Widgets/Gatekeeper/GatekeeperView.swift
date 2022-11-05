//
//  GatekeeperView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

struct GatekeeperView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel
    @Environment(\.keyboard) private var keyboard: Keyboard

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    HStack {
                        Spacer(minLength: 20)
                        VStack {
                            Spacer(minLength: 20)
                            // poor man's switch...
                            if viewModel.page == .login {
                                LoginView()
                            }
                            if viewModel.page == .createAccount {
                                CreateAccountView()
                            }
                            if viewModel.page == .forgotPassword {
                                ForgotPasswordView()
                            }
                            Spacer(minLength: 20)
                        }
                        .frame(
                            minWidth: 300,
                            maxWidth: 400,
                            minHeight: geometry.size.height - keyboard.height
                        )
                        Spacer(minLength: 20)
                    }
                }
                .frame(maxHeight: geometry.size.height - keyboard.height)
                if viewModel.isLoading {
                    SpinnerView()
                }
            }
            Spacer()
        }
        .textFieldStyle(UnderlinedTextFieldStyle())
        .buttonStyle(OutlinedFormButton())
        .font(.system(size: 20, weight: .light))
        .animation(
            .linear(duration: Double(keyboard.animationDuration)),
            value: keyboard.height
        )
    }
}

class GatekeeperViewModel: ObservableObject {
    enum Page {
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

    func register() {}

    func login() {}

    func recover() {}
}
