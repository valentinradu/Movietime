//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import Foundation

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
        case let .code(_, reason):
            return reason
        }
    }
}

public protocol RemoteServiceProtocol {
    func fetch<V>(_ request: URLRequest, of: V.Type) async throws -> V where V: Decodable
}

public struct RemoteService: RemoteServiceProtocol {
    public func fetch<V>(_ request: URLRequest, of: V.Type) async throws -> V where V: Decodable {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else { throw APIError.unknown }
        guard 200 ..< 300 ~= response.statusCode else {
            throw APIError.code(
                response.statusCode,
                message: String(data: data, encoding: .utf8) ?? ""
            )
        }

        let decoder = JSONDecoder()
        return try decoder.decode(V.self, from: data)
    }
}
