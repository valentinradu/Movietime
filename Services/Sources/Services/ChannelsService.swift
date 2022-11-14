//
//  File.swift
//  
//
//  Created by Valentin Radu on 14/11/2022.
//

import Foundation

public protocol ChannelsServiceProtocol {
    func register(firstName: String, lastName: String, email: String, password: String) async throws
    func login(email: String, password: String) async throws
    func forgotPassword(email: String) async throws
}

public struct ChannelsService: AuthServiceProtocol {
    let identityReady: 
}
