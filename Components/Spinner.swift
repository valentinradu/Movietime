//
//  Spinner.swift
//  Components
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Assets


public struct Spinner: View {
    @State private var ratio: Double = 0.0

    private var animation: Animation {
        Animation
            .easeOut(duration: 1.5)
            .repeatForever(autoreverses: false)
    }

    public init() {}
    public var body: some View {
        GeometryReader { geometry in
            Group {
                Ring(ratio: self.ratio)
                    .stroke(Color.accentColor, lineWidth: 10)
                    .frame(width: 50, height: 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.opacity(0.8))
            .onAppear() {
                withAnimation(self.animation) {
                    self.ratio = 1.0
                }
            }
        }
    }
}

private struct Ring: Shape {
    var ratio: Double
    let lag = 0.25

    func path(in rect: CGRect) -> Path {
        let end = ratio * 360
        let start: Double

        if ratio > (1 - lag) {
            start = 360 * (2 * ratio - 1.0)
        }
        else if ratio > lag {
            start = 360 * (ratio - lag)
        }
        else {
            start = 0
        }

        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                    radius: rect.size.width/2,
                    startAngle: Angle(degrees: start),
                    endAngle: Angle(degrees: end),
                    clockwise: false)
        return path
    }

    var animatableData: Double {
        get { return ratio }
        set { ratio = newValue }
    }
}

