//
//  Model.swift
//  Model
//
//  Created by Valentin Radu on 11/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Foundation

public struct User {
    public let username: String
}

public struct Movie: Codable, Hashable {
    public let title: String
    public let year: String
    public let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

public class Model {
    @Published public var user: User? = nil
    @Published public var movies: [Movie] = []

    let apiKey: String
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
