
//
//  Collection.swift
//  Movies
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

private struct MovieItem: View {
    let movie: MovieLens

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.itemBackground)
                AsyncImage(url: movie.posterURL)
                Text(verbatim: movie.year)
                    .padding(5)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white)
                    .background {
                        Rectangle()
                            .fill(Color.lightText)
                            .opacity(0.8)
                    }
            }.frame(height: 179)
            Text(verbatim: movie.title)
                .foregroundColor(.lightText)
                .font(.system(size: 12, weight: .light))
                .lineLimit(1)
                .truncationMode(.tail)
                .scaledToFit()
        }
        .frame(width: 125)
        .padding(10)
        .background(
            Color.white
                .shadow(
                    color: Color.black.opacity(0.25),
                    radius: 1,
                    x: 0,
                    y: 1
                )
        )
    }
}

struct MoviesView: View {
    @ObservedObject var state: MoviesViewState
    @Environment(\.keyboard) private var keyboard: Keyboard

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TextField(.searchMovie, text: $state.searchTerm)
                Spacer(minLength: 20).layoutPriority(-1)
                FlowView(data: state.movies) { movie in
                    MovieItem(movie: movie)
                }
            }.frame(height: geometry.size.height - keyboard.height)
            Spacer(minLength: 0)
        }
        .textFieldStyle(UnderlinedTextFieldStyle())
        .buttonStyle(OutlinedFormButton())
        .font(.system(size: 20, weight: .light))
        .animation(
            .linear(duration: Double(keyboard.animationDuration)),
            value: keyboard.height
        )
    }
}
