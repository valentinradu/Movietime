//
//  Login.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: $viewModel.email)
                SecureField(.password, text: $viewModel.password)
            }
            VStack(alignment: .center, spacing: 20) {
                viewModel.loginError.map { Text($0.errorDescription ?? "") }
                Button(action: { viewModel.login() }) {
                    Text(.login)
                }.buttonStyle(FilledFormButton())
                Button(action: { viewModel.page = .createAccount }) { Text(.createAccount) }
                Button(action: { viewModel.page = .forgotPassword }) { Text(.forgotPassword) }
            }
        }
    }
}
