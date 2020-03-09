//
//  Login.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Modifiers
import Styles


struct LoginView: View {
    @EnvironmentObject private var model: GatekeeperModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                TextField(.email, text: self.$model.email)
                SecureField(.password, text: self.$model.password)
            }
            VStack(alignment: .center, spacing: 20) {
                model.loginError.map { Text($0.errorDescription ?? "") }
                Button(action: {self.model.login()}) {
                    Text(.login)
                }.buttonStyle(FilledFormButton())
                Button(action: {self.model.page = .createAccount}) {Text(.createAccount)}
                Button(action: {self.model.page = .forgotPassword}) {Text(.forgotPassword)}
            }
        }
    }
}
