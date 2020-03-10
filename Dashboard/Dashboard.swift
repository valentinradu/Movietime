//
//  Dashboard.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Remotes
import Movies
import Components
import Model
import Combine


public struct DashboardView: View {
    @EnvironmentObject private var viewModel: DashboardViewModel
    @State private var progress: CGFloat = 0 {
        didSet {
            if progress > 1 || progress < 0 {
                progress = oldValue
            }
        }
    }
    private let tolerance: CGFloat = 0.2
    private let overlap: CGFloat = 0.3

    public init() {}

    private func dragGesture(start: CGFloat, end: CGFloat) -> some Gesture {
        let length: CGFloat = abs(end - start)
        return DragGesture()
            .onChanged { self.progress = (start + $0.translation.width) / length }
            .onEnded { e in
                if abs(start / length - self.progress) > self.tolerance {
                    self.viewModel.isMenuOpen.toggle()
                    self.progress = end / length
                }
                else {
                    self.progress = start / length
                }
            }
    }

    private func innerBody(_ geometry: GeometryProxy) -> some View {
        let length = geometry.size.width * (1 - overlap)
        let start: CGFloat = self.viewModel.isMenuOpen ? length : 0
        let end: CGFloat = self.viewModel.isMenuOpen ? 0 : length
        let padding: CGFloat = 20

        return ZStack() {
                MenuView()
                VStack {
                    HStack {
                        Spacer()
                        MenuIcon(progress: progress)
                            .foregroundColor(.darkForeground)
                            .offset(x: -progress * (length + padding))
                            .onTapGesture {
                                self.viewModel.isMenuOpen.toggle()
                                self.progress = end / length
                            }
                    }
                    .padding(padding)
                    MoviesList()
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.lightBackground.edgesIgnoringSafeArea(.all))
                .offset(x: progress * length)
        }
        .background(Color.darkBackground.edgesIgnoringSafeArea(.all))
        .animation(.interactiveSpring())
        .gesture(dragGesture(start: start, end: end))
    }

    public var body: some View {
        GeometryReader { geometry in
            self.innerBody(geometry)
        }
    }
}


private var cancellables: Set<AnyCancellable> = []
public class DashboardViewModel: ObservableObject {
    @Published var isMenuOpen: Bool = false
    @Published var username: String = ""

    private var model: Model
    public init(model: Model) {
        self.model = model
        model.user.$current
            .sink {[unowned self] user in
                self.username = user?.username ?? ""
            }
            .store(in: &cancellables)
    }

    func logout() {
        model.user.current = nil
    }
}
