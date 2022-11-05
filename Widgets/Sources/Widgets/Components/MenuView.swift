//
//  Menu.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var viewModel: DashboardViewModel
    var body: some View {
        VStack {
            Spacer().layoutPriority(1)
            HStack {
                Text(viewModel.username)
                Divider().background(Color.lightBackground)
                Button(action: { viewModel.logout() }) {
                    Text(.logout)
                }.buttonStyle(TextButton())
                Spacer()
            }
        }
        .foregroundColor(.lightText)
        .padding(20)
    }
}
