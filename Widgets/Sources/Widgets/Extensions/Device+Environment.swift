//
//  Modifiers.swift
//  Gatekeeper
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct UIUserInterfaceIdiomEnvironmentKey: EnvironmentKey {
    static var defaultValue: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
}

struct UIDeviceOrientationEnvironmentKey: EnvironmentKey {
    static var defaultValue: UIDeviceOrientation = UIDevice.current.orientation
}

extension EnvironmentValues {
    var userInterfaceIdiom: UIUserInterfaceIdiom {
        get { self[UIUserInterfaceIdiomEnvironmentKey.self] }
        set { self[UIUserInterfaceIdiomEnvironmentKey.self] = newValue }
    }

    var deviceOrientation: UIDeviceOrientation {
        get { self[UIDeviceOrientationEnvironmentKey.self] }
        set { self[UIDeviceOrientationEnvironmentKey.self] = newValue }
    }
}

extension View {
    func userInterfaceIdiom(_ newValue: UIUserInterfaceIdiom) -> some View {
        transformEnvironment(\.userInterfaceIdiom, transform: { r in
            r = newValue
        })
    }

    func deviceOrientation(_ newValue: UIDeviceOrientation) -> some View {
        transformEnvironment(\.deviceOrientation, transform: { r in
            r = newValue
        })
    }
}
