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
    @EnvironmentObject private var model: GatekeeperModel
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: $model.email)
            }
            VStack(alignment: .center, spacing: 20) {
                model.recoverError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.model.recover()}) {
                    Text(.recover)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.model.page = .login}) { Text(.rememberedPassword) }
            }
        }
    }
}
