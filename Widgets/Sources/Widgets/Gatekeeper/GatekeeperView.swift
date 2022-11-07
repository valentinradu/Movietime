//
//  GatekeeperView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

struct GatekeeperView: View {
    @ObservedObject var state: GatekeeperState
    @Environment(\.keyboard) private var keyboard: Keyboard

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    HStack {
                        Spacer(minLength: 20)
                        VStack {
                            Spacer(minLength: 20)
                            switch state.page {
                            case .login:
                                LoginView(state: state)
                            case .createAccount:
                                CreateAccountView(state: state)
                            case .forgotPassword:
                                ForgotPasswordView(state: state)
                            }
                            Spacer(minLength: 20)
                        }
                        .frame(
                            minWidth: 300,
                            maxWidth: 400,
                            minHeight: geometry.size.height - keyboard.height
                        )
                        Spacer(minLength: 20)
                    }
                }
                .frame(maxHeight: geometry.size.height - keyboard.height)
                if state.isLoading {
                    SpinnerView()
                }
            }
            Spacer()
        }
        .textFieldStyle(UnderlinedTextFieldStyle())
        .buttonStyle(OutlinedFormButton())
        .font(.system(size: 20, weight: .light))
        .animation(
            .linear(duration: Double(keyboard.animationDuration)),
            value: keyboard.height
        )
    }
}
