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

public protocol RemoteServiceProtocol {
    func register(firstName: String, lastName: String, email: String, password: String) async throws
    func login(email: String, password: String) async throws
    func forgotPassword(email: String) async throws
    func searchMovies(with query: String) async throws -> [Movie]
}

private struct SearchResponse: Codable {
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

public actor MainRemoteService: RemoteServiceProtocol {
    // The session could hold the user token and be mutated as requied (i.e after login/register)
    private let session: Session = .init()
    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func register(firstName: String, lastName: String, email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func login(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func forgotPassword(email: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func searchMovies(with query: String) async throws -> [Movie] {
        let host = "http://www.omdbapi.com"
        let term = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: "\(host)/?apikey=\(apiKey)&s=\(term)")!
        let request = URLRequest(url: url)
        let response = try await session.fetch(request, of: SearchResponse.self)
        return response.search
    }
}
