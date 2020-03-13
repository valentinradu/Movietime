//
//  Movies.swift
//  Model
//
//  Created by Valentin Radu on 12/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import Foundation
import Combine


private struct Response: Codable {
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

public extension Model {
    func search(term initialTerm: String) -> AnyPublisher<APIError?, Never> {

        if initialTerm.count < 3 {
            return Just<APIError?>(nil).eraseToAnyPublisher()
        }

        let host = "http://www.omdbapi.com"
        let term = initialTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: "\(host)/?apikey=\(apiKey)&s=\(term)")!
        let request = URLRequest(url: url)
        return fetch(request)
            .receive(on: RunLoop.main)
            .tryMap({data in
                let decoder = JSONDecoder()
                let res = try decoder.decode(Response.self, from: data)
                self.movies = res.search
                return nil
            })
            .mapError({error in
                guard let e = error as? APIError else { return .malformed }
                return e
            })
            .catch({error in Just(Optional(error))})
            .eraseToAnyPublisher()
    }
}
