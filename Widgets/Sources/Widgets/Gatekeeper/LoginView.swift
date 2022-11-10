//
//  Login.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var store: GatekeeperStore

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: store.bind(\.email, to: GatekeeperMutation.updateEmail))
                SecureField(.password, text: store.bind(\.password, to: GatekeeperMutation.updatePassword))
            }
            VStack(alignment: .center, spacing: 20) {
                store.state.loginError.map { Text($0) }
                Button(action: { store.dispatch(.login) }) {
                    Text(.login)
                }.buttonStyle(FilledFormButton())
                Button(action: { store.dispatch(.navigateTo(.createAccount)) }) {
                    Text(.createAccount)
                }
                Button(action: { store.dispatch(.navigateTo(.forgotPassword)) }) {
                    Text(.forgotPassword)
                }
            }
        }
    }
}
