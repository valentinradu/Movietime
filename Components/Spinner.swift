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
    @State private var progress: Double = 0.0

    private var animation: Animation {
        Animation
            .easeOut(duration: 1.5)
            .repeatForever(autoreverses: false)
    }

    public init() {}
    public var body: some View {
        GeometryReader { geometry in
            Group {
                Ring(progress: self.progress)
                    .stroke(Color.accentColor, lineWidth: 10)
                    .frame(width: 50, height: 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.opacity(0.8))
            .onAppear() {
                withAnimation(self.animation) {
                    self.progress = 1.0
                }
            }
        }
    }
}

private struct Ring: Shape {
    var progress: Double
    let lag = 0.25

    func path(in rect: CGRect) -> Path {
        let end = progress * 360
        let start: Double

        if progress > (1 - lag) {
            start = 360 * (2 * progress - 1.0)
        }
        else if progress > lag {
            start = 360 * (progress - lag)
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
        get { return progress }
        set { progress = newValue }
    }
}

