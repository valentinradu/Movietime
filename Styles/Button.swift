//
//  Button.swift
//  Movietime
//
//  Created by Valentin Radu on 08/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI

public struct FilledFormButton: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Self.Configuration) -> some View {
        let color: Color = configuration.isPressed ? .buttonPressed : .buttonNormal
        return HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .padding(20)
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(4)
    }
}

public struct OutlinedFormButton: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Self.Configuration) -> some View {
        let color: Color = configuration.isPressed ? .buttonPressed : .buttonNormal
        return HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .padding(20)
        .foregroundColor(color)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(color, lineWidth: 1)
        )
    }
}

public struct TextButton: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Self.Configuration) -> some View {
        let color: Color = configuration.isPressed ? .buttonPressed : .buttonNormal
        return configuration.label
            .foregroundColor(color)
    }
}
