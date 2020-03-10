//
//  Menu.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI


struct MenuView: View {
    @EnvironmentObject private var viewModel: DashboardViewModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(viewModel.username)
                Divider()
                Button(action: {self.viewModel.logout()}) {
                    Text(.logout)
                }
            }
        }
    }
}
