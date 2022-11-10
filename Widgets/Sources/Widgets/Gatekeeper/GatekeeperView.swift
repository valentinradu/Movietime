//
//  GatekeeperView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

private struct GatekeeperPageView: View {
    let page: GatekeeperState.Page
    @ObservedObject var store: GatekeeperStore

    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    switch page {
                    case .login:
                        LoginView(store: store)
                    case .createAccount:
                        CreateAccountView(store: store)
                    case .forgotPassword:
                        ForgotPasswordView(store: store)
                    }
                }
                .textFieldStyle(UnderlinedTextFieldStyle())
                .buttonStyle(OutlinedFormButton())
                .font(.system(size: 20, weight: .light))
                .padding(.all, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            if store.state.isLoading {
                SpinnerView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct GatekeeperView: View {
    @ObservedObject var store: GatekeeperStore

    var body: some View {
        NavigationStack(path: store.bind(\.pages, to: GatekeeperMutation.updatePages)) {
            LoginView(store: store)
                .navigationDestination(for: GatekeeperState.Page.self) { page in
                    GatekeeperPageView(page: page, store: store)
                }
                .textFieldStyle(UnderlinedTextFieldStyle())
                .buttonStyle(OutlinedFormButton())
                .font(.system(size: 20, weight: .light))
                .padding(.all, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}
