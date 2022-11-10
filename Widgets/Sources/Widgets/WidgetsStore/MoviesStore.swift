//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Foundation
import Hako
import Services
import UIKit.UIImage

typealias MoviesStore = Store<MoviesState, any MoviesEnvProtocol>
typealias MoviesMutation = Mutation<MoviesState, any MoviesEnvProtocol>

struct MoviesState: Equatable {
    var searchTerm: String = ""
    var searchErrorMessage: String?
    var movies: [MovieLens] = []
}

struct MovieLens: Hashable {
    let title: String
    let year: String
    let posterURL: URL
}

extension MovieLens {
    init(with movie: Movie) {
        self.init(title: movie.title,
                  year: movie.year,
                  posterURL: movie.posterURL)
    }
}

public protocol MoviesEnvProtocol {
    associatedtype RemoteService: RemoteServiceProtocol
    var remoteService: RemoteService { get }
}

extension MoviesMutation where Self == MoviesMutation {
    static func updateSearch(_ value: String) -> MoviesMutation {
        if value.count > 3 {
            return Mutation { state in
                state.searchTerm = value
                return SideEffect { env in
                    do {
                        let movies = try await env.remoteService.searchMovies(with: value)
                        return Mutation { state in
                            state.movies = movies.map(MovieLens.init)
                            return .noop
                        }
                    } catch {
                        return Mutation { state in
                            state.searchErrorMessage = error.localizedDescription
                            return .noop
                        }
                    }
                }
            }
        } else {
            return Mutation { state in
                state.searchTerm = value
                return .noop
            }
        }
    }

    static var dismissAlert: MoviesMutation {
        Mutation { state in
            state.searchErrorMessage = nil
            return .noop
        }
    }
}
