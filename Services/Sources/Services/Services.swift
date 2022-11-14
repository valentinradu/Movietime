//
//  File.swift
//
//
//  Created by Valentin Radu on 12/11/2022.
//

import Foundation

@propertyWrapper
public struct Service<Value> {
    private let _key: KeyPath<ServiceProvider, Value>
    public init(_ key: KeyPath<ServiceProvider, Value>) {
        _key = key
    }

    public var wrappedValue: Value {
        ServiceFactory.main[keyPath: _key]
    }
}

public protocol ServiceProvider {
    var remote: RemoteServiceProtocol { get }
    var movies: MoviesServiceProtocol { get }
    var auth: AuthServiceProtocol { get }
    var channels: ChannelsServiceProtocol { get }
}

struct ServiceFactory: ServiceProvider {
    public static var main: ServiceProvider = ServiceFactory()

    let remote: RemoteServiceProtocol = RemoteService()
    let movies: MoviesServiceProtocol = MoviesService()
    let auth: AuthServiceProtocol = AuthService()
    let channels: ChannelsServiceProtocol = ChannelsService()
}
