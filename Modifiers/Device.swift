//
//  Modifiers.swift
//  Gatekeeper
//
//  Created by Valentin Radu on 09/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI


public struct UIUserInterfaceIdiomEnvironmentKey: EnvironmentKey {
    public static var defaultValue: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
}

public struct UIDeviceOrientationEnvironmentKey: EnvironmentKey {
    public static var defaultValue: UIDeviceOrientation = UIDevice.current.orientation
}


public extension EnvironmentValues {
    var userInterfaceIdiom: UIUserInterfaceIdiom {
        get {self[UIUserInterfaceIdiomEnvironmentKey.self]}
        set {self[UIUserInterfaceIdiomEnvironmentKey.self] = newValue}
    }
    var deviceOrientation: UIDeviceOrientation {
        get {self[UIDeviceOrientationEnvironmentKey.self]}
        set {self[UIDeviceOrientationEnvironmentKey.self] = newValue}
    }
}


public extension View {
    func userInterfaceIdiom(_ newValue: UIUserInterfaceIdiom) -> some View {
        return self.transformEnvironment(\.userInterfaceIdiom, transform: {r in
            r = newValue
        })
    }
    func deviceOrientation(_ newValue: UIDeviceOrientation) -> some View {
        return self.transformEnvironment(\.deviceOrientation, transform: {r in
            r = newValue
        })
    }
}
