
//
//  Collection.swift
//  Movies
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI
import Styles
import Modifiers
import Model
import Assets
import Components
import Combine

private class ImageProvider: ObservableObject {
    @Published var data: Data? = nil

    private var cancellables: Set<AnyCancellable> = []
    func load(url: URL) {
        if url.scheme?.starts(with: "http") == true {
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: RunLoop.main)
                .map({ data, response in
                    guard let res = response as? HTTPURLResponse else { return nil }
                    guard 200..<300 ~= res.statusCode else { return nil }
                    return Optional(data)
                })
                .catch({_ in Just(nil)})
                .assign(to: \.data, on: self)
                .store(in: &cancellables)
        }
    }
}

private struct MovieItem: View {
    let movie: Movie
    @ObservedObject var provider: ImageProvider = .init()
    init(movie: Movie) {
        self.movie = movie
        if let url = URL(string: movie.poster) {
            provider.load(url: url)
        }
    }
    var body: some View {
        let image = self.provider.data.flatMap({r in UIImage(data: r, scale: 2)})
        return VStack {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.itemBackground)
                image
                    .flatMap({ r in Image(uiImage: r).resizable()})
                Text(verbatim: self.movie.year)
                    .padding(5)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white)
                    .background(Rectangle().fill(Color.lightText).opacity(0.8))
            }.frame(height: 179)
            Text(verbatim: self.movie.title)
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
                    y: 1)
        )
    }
}

public struct MoviesView: View {
    @EnvironmentObject private var viewModel: MoviesViewModel
    @Environment(\.keyboard) private var keyboard: Keyboard
    public init() {}
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TextField(.searchMovie, text: self.$viewModel.searchTerm)
                Spacer(minLength: 20).layoutPriority(-1)
                FlowView(data: self.viewModel.movies) { movie in
                    MovieItem(movie: movie)
                }
            }.frame(height: geometry.size.height - self.keyboard.height)
            Spacer(minLength: 0)
        }
        .textFieldStyle(UnderlinedTextFieldStyle())
        .buttonStyle(OutlinedFormButton())
        .font(.system(size: 20, weight: .light))
        .animation(
            .linear(duration: Double(keyboard.animationDuration)),
            value: keyboard.height)
    }
}

public class MoviesViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var movies: [Movie] = []


    private let model: Model
    private var cancellables: Set<AnyCancellable> = []
    public init(model: Model) {
        self.model = model
        model.$movies
            .sink(receiveValue: {[unowned self] value in
                self.movies = value
            })
            .store(in: &cancellables)
        $searchTerm.sink(receiveValue: {[unowned self] value in
            self.model.search(term: value)
                .sink(receiveValue: {_ in})
                .store(in: &self.cancellables)
        })
        .store(in: &cancellables)
    }
}
