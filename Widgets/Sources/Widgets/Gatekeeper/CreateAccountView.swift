//
//  LoginView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct CreateAccountView: View {
    @ObservedObject var store: GatekeeperStore

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.firstName, text: store.bind(\.firstName, to: GatekeeperMutation.updateFirstName))
                TextField(.lastName, text: store.bind(\.lastName, to: GatekeeperMutation.updateLastName))
                TextField(.email, text: store.bind(\.email, to: GatekeeperMutation.updateEmail))
                SecureField(.password, text: store.bind(\.firstNewPassword, to: GatekeeperMutation.updateFirstNewPassword))
                SecureField(.passwordAgain, text: store.bind(\.secondNewPassword, to: GatekeeperMutation.updateSecondNewPassword))
            }
            VStack(alignment: .center, spacing: 20) {
                store.state.registerError.map { Text($0) }
                Button(action: { store.dispatch(.register) }) {
                    Text(.createAccount)
                }.buttonStyle(FilledFormButton())
                Button(action: { store.dispatch(.navigateTo(.login)) }) {
                    Text(.alreadyRegistered)
                }
                Button(action: { store.dispatch(.navigateTo(.forgotPassword)) }) {
                    Text(.forgotPassword)
                }
            }
        }
    }
}
