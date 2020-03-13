//
//  Fetch.swift
//  Remotes
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import Foundation
import Combine


public enum APIError: Error, LocalizedError {
    case unknown
    case malformed
    case code(_ code: Int, message: String)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .malformed:
            return "The server response was malformed"
        case .code(_, let reason):
            return reason
        }
    }
}

func fetch(_ request: URLRequest) -> AnyPublisher<Data, APIError> {
    return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { data, response in
            guard let res = response as? HTTPURLResponse else { throw APIError.unknown }
            guard 200..<300 ~= res.statusCode else {
                throw APIError.code(
                    res.statusCode,
                    message: String(data: data, encoding: .utf8) ?? "")
            }
            return data
        }
        .mapError { error in
            if let error = error as? APIError {
                return error
            }
            else {
                return .unknown
            }
        }
        .eraseToAnyPublisher()
}
