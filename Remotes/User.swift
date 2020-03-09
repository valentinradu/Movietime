//
//  User.swift
//  Remotes
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import Foundation
import Combine

let baseUrl = "https://example.com"

public struct User {
    public let username: String
    // ... others ... //

    public static func register(firstName: String, lastName: String, email: String, password: String) -> AnyPublisher<User, APIError> {
        let url = URL(string: "\(baseUrl)")!
        let request = URLRequest(url: url)
        return fetch(request)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({_ in User(username: "rad_val")})
            .eraseToAnyPublisher()
    }

    public static func recoverPassword(email: String) -> AnyPublisher<(), APIError> {
        let url = URL(string: "\(baseUrl)/api")!
        let request = URLRequest(url: url)
        return fetch(request)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({_ in})
            .mapError({_ in APIError.code(404, message: "Email not found")})
            .eraseToAnyPublisher()
    }

    public static func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        let url = URL(string: "\(baseUrl)")!
        let request = URLRequest(url: url)
        return fetch(request)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({_ in User(username: "rad_val")})
            .eraseToAnyPublisher()
    }
}
