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
let fakeUser = User(username: "rad_val")


public struct User {
    public let username: String
}

public class UserModel {
    @Published public var current: User? = nil

    public init() {}
    public func register(firstName: String, lastName: String, email: String, password: String) -> AnyPublisher<APIError?, Never> {
        let url = URL(string: "\(baseUrl)")!
        let request = URLRequest(url: url)
        return fetch(request)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({_ in
                self.current = fakeUser
                return nil
            })
            .catch({error in Just(Optional(error))})
            .eraseToAnyPublisher()
    }

    public func recoverPassword(email: String) -> AnyPublisher<APIError?, Never> {
        let url = URL(string: "\(baseUrl)/api")!
        let request = URLRequest(url: url)
        return fetch(request)
            .map({_ in nil})
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .mapError({_ in APIError.code(404, message: "Email not found")})
            .catch({error in Just(Optional(error))})
            .eraseToAnyPublisher()
    }

    public func login(email: String, password: String) -> AnyPublisher<APIError?, Never> {
        let url = URL(string: "\(baseUrl)")!
        let request = URLRequest(url: url)
        return fetch(request)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({_ in
                self.current = fakeUser
                return nil
            })
            .catch({error in Just(Optional(error))})
            .eraseToAnyPublisher()
    }
}
