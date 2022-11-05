//
//  ContentView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI
import Gatekeeper
import Dashboard
import Modifiers
import Combine
import Model


struct MainView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                DashboardView().environmentObject(viewModel.dashboardViewModel)
            }
            else {
                GatekeeperView().environmentObject(viewModel.gatekeeperViewModel)
            }
        }
        .modifier(KeyboardAwareModifier())
    }
}


private var cancellables: Set<AnyCancellable> = []
class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    let gatekeeperViewModel: GatekeeperViewModel
    let dashboardViewModel: DashboardViewModel
    init(model: Model) {
        self.gatekeeperViewModel = .init(model: model)
        self.dashboardViewModel = .init(model: model)

        model.$user
            .map { $0 != nil }
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
    }
}
