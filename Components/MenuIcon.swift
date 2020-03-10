//
//  MenuIcon.swift
//  Components
//
//  Created by Valentin Radu on 10/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI

public struct MenuIcon: View {
    public let progress: CGFloat
    public init (progress: CGFloat) {
        self.progress = progress
    }
    public var body: some View {
        Bars(progress: progress)
            .frame(width: 30, height: 25, alignment: .leading)
    }
}

private struct Bars: Shape {
    var progress: CGFloat
    private let thickness: CGFloat = 4
    private let count: CGFloat = 3

    private func transformFor(_ index: CGFloat, in rect: CGRect) -> CGAffineTransform {
        precondition(index < count)
        precondition(count > 0)

        let spacing: CGFloat = (rect.height - count * thickness) / (count - 1)
        let y = index * (spacing + thickness)
        var transform: CGAffineTransform = .identity
        if index == 1 {
            transform = transform
                .scaledBy(x: (1 - progress), y: 1)
                .translatedBy(x: 0, y: y - thickness / 2)
        }
        else if index == 0 {
            transform = transform
                .translatedBy(x: 0, y: y)
                .rotated(by: .pi / 4 * progress)
                .translatedBy(x: 0, y: -thickness / 2)
        }
        else {
            transform = transform
                .translatedBy(x: 0, y: y)
                .rotated(by: -.pi / 4 * progress)
                .translatedBy(x: 0, y: -thickness / 2)
        }

        return transform
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for i in 0..<Int(count) {
            let line: CGRect = .init(x: 0, y: 0, width: rect.width, height: thickness)
            path.addRect(line, transform: transformFor(CGFloat(i), in: rect))
        }
        return path
    }

    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
}
