//
//  ContentView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Gatekeeper
import Dashboard
import Modifiers
import Remotes
import Combine


struct MainView: View {
    @EnvironmentObject private var model: MainModel
    var body: some View {
        Group {
            if model.user != nil {
                DashboardView()
                    .environmentObject(model.dashboardModel)
            }
            else {
                GatekeeperView()
                    .environmentObject(model.gatekeeperModel)
            }
        }
        .modifier(KeyboardAwareModifier())
    }
}

class MainModel: ObservableObject {
    @Published var user: User? = nil

    let gatekeeperModel: GatekeeperModel = .init()
    let dashboardModel: DashboardModel = .init()

    private var cancellables: Set<AnyCancellable> = []
    init() {
        gatekeeperModel.$user
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
}
