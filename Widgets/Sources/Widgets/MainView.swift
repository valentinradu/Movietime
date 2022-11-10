//
//  ContentView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

public struct MainView: View {
    @ObservedObject var store: WidgetsStore

    public init(store: WidgetsStore) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            if store.state.isLoggedIn {
                Suspense(store.env.fetchDashboardEnv) { env in
                    let dashboardStore = DashboardStore(state: .init(), env: env)
                    DashboardView(store: dashboardStore)
                }
            } else {
                Suspense(store.env.fetchGatekeeperEnv) { env in
                    let gatekeeperStore = GatekeeperStore(state: .init(), env: env)
                    GatekeeperView(store: gatekeeperStore)
                }
            }
        }
    }
}
