//
//  File.swift
//
//
//  Created by Valentin Radu on 12/11/2022.
//

import Foundation

public protocol AuthServiceProtocol {
    func register(firstName: String, lastName: String, email: String, password: String) async throws
    func login(email: String, password: String) async throws
    func forgotPassword(email: String) async throws
}

public actor AuthService: AuthServiceProtocol {
    public func register(firstName: String, lastName: String, email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func login(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func forgotPassword(email: String) async throws {
        try await Task.sleep(for: .seconds(1))
    }
}
