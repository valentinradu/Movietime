//
//  LoginView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct CreateAccountView: View {
    @ObservedObject var state: GatekeeperState
    @Environment(\.dispatch) private var dispatch

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.firstName, text: $state.firstName)
                TextField(.lastName, text: $state.lastName)
                TextField(.email, text: $state.email)
                SecureField(.password, text: $state.firstNewPassword)
                SecureField(.passwordAgain, text: $state.secondNewPassword)
            }
            VStack(alignment: .center, spacing: 20) {
                state.registerError.map { Text($0) }
                Button(action: { dispatch(.register) }) {
                    Text(.createAccount)
                }.buttonStyle(FilledFormButton())
                Button(action: { state.page = .login }) { Text(.alreadyRegistered) }
                Button(action: { state.page = .forgotPassword }) { Text(.forgotPassword) }
            }
        }
    }
}
