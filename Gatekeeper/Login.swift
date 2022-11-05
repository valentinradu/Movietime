//
//  Login.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI
import Modifiers
import Styles


struct LoginView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: self.$viewModel.email)
                SecureField(.password, text: self.$viewModel.password)
            }
            VStack(alignment: .center, spacing: 20) {
                viewModel.loginError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.viewModel.login()}) {
                    Text(.login)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.viewModel.page = .createAccount}) {Text(.createAccount)}
                Button(action: {self.viewModel.page = .forgotPassword}) {Text(.forgotPassword)}
            }
        }
    }
}
