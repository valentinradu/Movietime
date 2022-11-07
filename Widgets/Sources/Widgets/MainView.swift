//
//  ContentView.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var state: WidgetsState
    var body: some View {
        ZStack {
            if state.isLoggedIn {
                if let dashboardState = state.dashboardState {
                    DashboardView(state: dashboardState)
                }
            } else {
                if let gatekeeperState = state.gatekeeperState {
                    GatekeeperView(state: gatekeeperState)
                }
            }
        }
        .modifier(KeyboardAwareModifier())
    }
}
