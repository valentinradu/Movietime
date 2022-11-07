//
//  Login.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var state: GatekeeperState
    @Environment(\.dispatch) private var dispatch

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: $state.email)
                SecureField(.password, text: $state.password)
            }
            VStack(alignment: .center, spacing: 20) {
                state.loginError.map { Text($0) }
                Button(action: { dispatch(.navigateTo(.login)) }) {
                    Text(.login)
                }.buttonStyle(FilledFormButton())
                Button(action: { state.page = .createAccount }) {
                    Text(.createAccount)
                }
                Button(action: { state.page = .forgotPassword }) {
                    Text(.forgotPassword)
                }
            }
        }
    }
}
