//
//  ForgotPassword.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Styles


struct ForgotPasswordView: View {
    @EnvironmentObject private var viewModel: GatekeeperViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: $viewModel.email)
            }
            VStack(alignment: .center, spacing: 20) {
                viewModel.recoverError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.viewModel.recover()}) {
                    Text(.recover)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.viewModel.page = .login}) { Text(.rememberedPassword) }
            }
        }
    }
}
