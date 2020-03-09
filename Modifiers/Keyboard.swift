//
//  Keyboard.swift
//  Modifiers
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI
import Combine


public struct KeyboardInfoEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Keyboard = .init(height: 0, animationDuration: 0, animationCurve: .linear)
}

public extension EnvironmentValues {
    var keyboard: Keyboard {
        get {self[KeyboardInfoEnvironmentKey.self]}
        set {self[KeyboardInfoEnvironmentKey.self] = newValue}
    }
}

public extension View {
    func keyboard(_ newValue: Keyboard) -> some View {
        return self.transformEnvironment(\.keyboard, transform: {r in
            r = newValue
        })
    }
}

public struct Keyboard {
    public let height: CGFloat
    public let animationDuration: CGFloat
    public let animationCurve: UIView.AnimationCurve

    init(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            self.init(height: 0, animationDuration: 0, animationCurve: .linear)
            return
        }
        let animationDuration = CGFloat((userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.25)
        let animationCurve: UIView.AnimationCurve
        if let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw) ?? .linear
        }
        else {
            animationCurve = .linear
        }
        let height: CGFloat
        let screen = UIScreen.main
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
        if let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            if keyboardFrame.origin.y == screen.bounds.height {
                height = 0
            } else {
                height = keyboardFrame.height - (safeAreaInsets?.bottom ?? 0)
            }
        }
        else {
            height = 0
        }
        self.init(
            height: height,
            animationDuration: animationDuration,
            animationCurve: animationCurve)
    }

    init(height: CGFloat, animationDuration: CGFloat, animationCurve: UIView.AnimationCurve) {
        self.height = height
        self.animationDuration = animationDuration
        self.animationCurve = animationCurve
    }
}

private let notificationCenter = NotificationCenter.default
public struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboard: Keyboard = .init(height: 0, animationDuration: 0, animationCurve: .linear)
    private var keyboardPublisher = notificationCenter
        .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        .merge(with: notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification))
        .compactMap(Keyboard.init(notification:))

    public init() {}

    public func body(content: Content) -> some View {
        content.keyboard(keyboard).onReceive(keyboardPublisher) { r in
            self.keyboard = r
        }
    }
}
