//
//  ForgotPassword.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

private extension GatekeeperState {
    var isForgotAlertVisible: Bool {
        recoverMessage != nil
    }
}

struct ForgotPasswordView: View {
    @ObservedObject var store: GatekeeperStore

    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: store.bind(\.email, to: GatekeeperMutation.updateEmail))
            }
            VStack(alignment: .center, spacing: 20) {
                store.state.recoverError.map { Text($0) }
                Button(action: { store.dispatch(.forgotPassword) }) {
                    Text(.recover)
                }.buttonStyle(FilledFormButton())
                Button(action: { store.dispatch(.navigateTo(.login)) }) {
                    Text(.rememberedPassword)
                }
            }
        }
        .alert(
            .recoverAlertTitle,
            isPresented: store.bind(\.isForgotAlertVisible, to: { _ in GatekeeperMutation.dismissAlert })
        ) {
            EmptyView()
        } message: {
            if let message = store.state.recoverMessage {
                Text(message)
            }
        }
    }
}
