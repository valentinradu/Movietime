//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Foundation

public struct Movie: Codable, Hashable {
    public let title: String
    public let year: String
    public let posterURL: URL

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case posterURL = "Poster"
    }
}

public enum MoviesServiceError: Error {
    case movieNotFound
    case error(message: String)
}

public protocol MoviesServiceProtocol {
    func searchMovies(with query: String) async throws -> [Movie]
}

private struct SearchResponse: Decodable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case error = "Error"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let movies = try container.decodeIfPresent([Movie].self, forKey: .search) {
            self.movies = movies
        } else {
            let errorMessage = try container.decode(String.self, forKey: .error)
            if errorMessage.contains("not found") {
                throw MoviesServiceError.movieNotFound
            } else {
                throw MoviesServiceError.error(message: errorMessage)
            }
        }
    }
}

public actor MoviesService: MoviesServiceProtocol {
    // The session could hold the user token and be mutated as requied (i.e after login/register)
    private let apiKey: String
    private var lastSearchDate: Date
    private var lastSearchTask: Task<[Movie], Error>?

    @Service(\.remote) private var remoteService: RemoteServiceProtocol

    public init() {
        self.apiKey = ""
        lastSearchDate = .now
    }

    public func searchMovies(with query: String) async throws -> [Movie] {
        lastSearchTask?.cancel()
        let targetSearchDate = lastSearchDate.addingTimeInterval(0.3)
        lastSearchDate = .now

        let newTask: Task<[Movie], Error>
        if targetSearchDate < .now {
            newTask = Task {
                try await _searchMovies(with: query)
            }
        } else {
            newTask = Task {
                try await Task.sleep(for: .milliseconds(400))
                if Task.isCancelled {
                    throw CancellationError()
                }
                let movies = try await _searchMovies(with: query)
                return movies
            }
        }

        lastSearchTask = newTask
        let movies = try await newTask.value

        return movies
    }

    private func _searchMovies(with query: String) async throws -> [Movie] {
        let host = "http://www.omdbapi.com"
        let term = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: "\(host)/?apikey=\(apiKey)&s=\(term)")!
        let request = URLRequest(url: url)
        let response = try await remoteService.fetch(request, of: SearchResponse.self)
        if Task.isCancelled {
            throw CancellationError()
        }
        return response.movies
    }
}
