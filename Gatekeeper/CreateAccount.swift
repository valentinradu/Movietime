//
//  LoginView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI
import Assets
import Styles


struct CreateAccountView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.firstName, text: $viewModel.firstName)
                TextField(.lastName, text: $viewModel.lastName)
                TextField(.email, text: $viewModel.email)
                SecureField(.password, text: $viewModel.firstNewPassword)
                SecureField(.passwordAgain, text: $viewModel.secondNewPassword)
            }
            VStack(alignment: .center, spacing: 20) {
                viewModel.registerError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.viewModel.register()}) {
                    Text(.createAccount)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.viewModel.page = .login}) { Text(.alreadyRegistered) }
                Button(action: {self.viewModel.page = .forgotPassword}) { Text(.forgotPassword) }
            }
        }
    }
}
