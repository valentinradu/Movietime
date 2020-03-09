//
//  LoginView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Assets
import Styles


struct CreateAccountView: View {
    @EnvironmentObject private var model: GatekeeperModel
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.firstName, text: $model.firstName)
                TextField(.lastName, text: $model.lastName)
                TextField(.email, text: $model.email)
                SecureField(.password, text: $model.firstNewPassword)
                SecureField(.passwordAgain, text: $model.secondNewPassword)
            }
            VStack(alignment: .center, spacing: 20) {
                model.registerError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.model.register()}) {
                    Text(.createAccount)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.model.page = .login}) { Text(.alreadyRegistered) }
                Button(action: {self.model.page = .forgotPassword}) { Text(.forgotPassword) }
            }
        }
    }
}
