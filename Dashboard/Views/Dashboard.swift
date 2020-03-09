//
//  Dashboard.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI

public struct DashboardView: View {
    public init() {}
    @EnvironmentObject private var model: DashboardModel
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

public class DashboardModel: ObservableObject {
    public init() {}
    
}
