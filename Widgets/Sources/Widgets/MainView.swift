//
//  ContentView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                DashboardView()
            } else {
                GatekeeperView()
            }
        }
        .modifier(KeyboardAwareModifier())
    }
}

class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
