//
//  File.swift
//
//
//  Created by Valentin Radu on 09/11/2022.
//

import SwiftUI

public struct Suspense<V, C>: View where C: View {
    private let contentBuilder: (V) -> C
    private let fetch: () async throws -> V
    @State private var value: Result<V, Error>?

    public init(_ fetch: @escaping () async throws -> V,
                @ViewBuilder _ contentBuilder: @escaping (V) -> C) {
        self.contentBuilder = contentBuilder
        self.fetch = fetch
    }

    public var body: some View {
        ZStack {
            switch value {
            case let .success(value):
                contentBuilder(value)
            case let .failure(error):
                Text(verbatim: String(describing: error))
                EmptyView()
            case .none:
                EmptyView()
            }
        }
        .task {
            do {
                let result = try await fetch()
                value = .success(result)
            } catch {
                value = .failure(error)
            }
        }
    }
}
