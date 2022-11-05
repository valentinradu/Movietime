//
//  Button.swift
//  Movietime
//
//  Created by Valentin Radu on 08/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct FilledFormButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
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

struct OutlinedFormButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
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

struct TextButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        let color: Color = configuration.isPressed ? .buttonPressed : .buttonNormal
        return configuration.label
            .foregroundColor(color)
    }
}
