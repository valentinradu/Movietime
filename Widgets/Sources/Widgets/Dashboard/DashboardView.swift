//
//  Dashboard.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

struct DashboardView: View {
    @ObservedObject var store: DashboardStore
    @State private var progress: CGFloat = 0 {
        didSet {
            if progress > 1 || progress < 0 {
                progress = oldValue
            }
        }
    }

    private let tolerance: CGFloat = 0.2
    private let overlap: CGFloat = 0.2

    private func dragGesture(start: CGFloat, end: CGFloat) -> some Gesture {
        let length: CGFloat = abs(end - start)
        return DragGesture()
            .onChanged { progress = (start + $0.translation.width) / length }
            .onEnded { e in
                if abs(start / length - progress) > tolerance {
                    store.dispatch(.toggleMenu)
                    progress = end / length
                } else {
                    progress = start / length
                }
            }
    }

    private func innerBody(_ geometry: GeometryProxy) -> some View {
        let length = geometry.size.width * (1 - overlap)
        let start: CGFloat = store.state.isMenuOpen ? length : 0
        let end: CGFloat = store.state.isMenuOpen ? 0 : length
        let padding: CGFloat = 20

        return ZStack(alignment: .topLeading) {
            MenuView(store: store)
                .frame(width: geometry.size.width, height: geometry.size.height)
            VStack {
                HStack {
                    Spacer()
                    MenuIcon(progress: progress)
                        .foregroundColor(.darkForeground)
                        .offset(x: -progress * length)
                        .onTapGesture {
                            store.dispatch(.toggleMenu)
                            progress = end / length
                        }
                }
                Spacer(minLength: 20).layoutPriority(-1)
                Suspense(store.env.fetchMoviesEnv) { env in
                    let movieStore = MoviesStore(state: .init(), env: env)
                    MoviesView(store: movieStore)
                        .offset(x: progress * geometry.size.width * overlap)
                }

                Spacer()
            }
            .padding(padding)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.lightBackground.edgesIgnoringSafeArea(.all))
            .offset(x: progress * length)
        }
        .font(.system(size: 20, weight: .light))
        .background(Color.darkBackground.edgesIgnoringSafeArea(.all))
        .animation(.interactiveSpring(), value: progress)
        .gesture(dragGesture(start: start, end: end))
    }

    var body: some View {
        GeometryReader { geometry in
            innerBody(geometry)
        }
    }
}
