//
//  ForgotPassword.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var state: GatekeeperState
    @Environment(\.dispatch) private var dispatch

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: $state.email)
            }
            VStack(alignment: .center, spacing: 20) {
                state.recoverError.map { Text($0) }
                Button(action: { dispatch(.navigateTo(.forgotPassword)) }) {
                    Text(.recover)
                }.buttonStyle(FilledFormButton())
                Button(action: { state.page = .login }) {
                    Text(.rememberedPassword)
                }
            }
        }
    }
}
