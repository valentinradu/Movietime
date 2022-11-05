//
//  Keyboard.swift
//  Modifiers
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import SwiftUI

struct KeyboardInfoEnvironmentKey: EnvironmentKey {
    static var defaultValue: Keyboard = .init(height: 0, animationDuration: 0, animationCurve: .linear)
}

extension EnvironmentValues {
    var keyboard: Keyboard {
        get { self[KeyboardInfoEnvironmentKey.self] }
        set { self[KeyboardInfoEnvironmentKey.self] = newValue }
    }
}

extension View {
    func keyboard(_ newValue: Keyboard) -> some View {
        transformEnvironment(\.keyboard, transform: { r in
            r = newValue
        })
    }
}

struct Keyboard {
    let height: CGFloat
    let animationDuration: CGFloat
    let animationCurve: UIView.AnimationCurve

    init(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            self.init(height: 0, animationDuration: 0, animationCurve: .linear)
            return
        }
        let animationDuration = CGFloat((userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.25)
        let animationCurve: UIView.AnimationCurve
        if let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw) ?? .linear
        } else {
            animationCurve = .linear
        }
        let height: CGFloat
        let screen = UIScreen.main
        if let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            if keyboardFrame.origin.y == screen.bounds.height {
                height = 0
            } else {
                height = keyboardFrame.height
            }
        } else {
            height = 0
        }
        self.init(
            height: height,
            animationDuration: animationDuration,
            animationCurve: animationCurve
        )
    }

    init(height: CGFloat, animationDuration: CGFloat, animationCurve: UIView.AnimationCurve) {
        self.height = height
        self.animationDuration = animationDuration
        self.animationCurve = animationCurve
    }
}

private let notificationCenter = NotificationCenter.default
struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboard: Keyboard = .init(height: 0, animationDuration: 0, animationCurve: .linear)
    private var keyboardPublisher = notificationCenter
        .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        .merge(with: notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification))
        .compactMap(Keyboard.init(notification:))

    func body(content: Content) -> some View {
        content.keyboard(keyboard).onReceive(keyboardPublisher) { r in
            keyboard = r
        }
    }
}
