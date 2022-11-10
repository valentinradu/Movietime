
//
//  Collection.swift
//  Movies
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

private extension MoviesState {
    var isMoviesAlertVisible: Bool {
        searchErrorMessage != nil
    }
}

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
    @ObservedObject var store: MoviesStore

    var body: some View {
        VStack {
            TextField(.searchMovie, text: store.bind(\.searchTerm, to: MoviesMutation.updateSearch))
            Spacer(minLength: 20).layoutPriority(-1)
            FlowView(data: store.state.movies) { movie in
                MovieItem(movie: movie)
            }
        }
        .frame(maxWidth: .infinity)
        .alert(
            .moviesAlertTitle,
            isPresented: store.bind(\.isMoviesAlertVisible, to: { _ in MoviesMutation.dismissAlert })
        ) {
            EmptyView()
        } message: {
            if let message = store.state.searchErrorMessage {
                Text(message)
            }
        }
    }
}
