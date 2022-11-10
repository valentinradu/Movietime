//
//  SceneDelegate.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import Combine
import Services
import SwiftUI
import UIKit
import Widgets

struct MainGatekeeperEnv: GatekeeperEnvProtocol {
    let identityReady: PassthroughSubject<Bool, Never>
    let remoteService: MainRemoteService

    init(identityReady: PassthroughSubject<Bool, Never>,
         remoteService: MainRemoteService) {
        self.identityReady = identityReady
        self.remoteService = remoteService
    }
}

struct MainWidgetsEnv: WidgetsEnvProtocol {
    let identityReady: PassthroughSubject<Bool, Never>
    let remoteService: MainRemoteService

    init(remoteService: MainRemoteService) {
        identityReady = .init()
        self.remoteService = remoteService
    }

    func fetchGatekeeperEnv() async -> MainGatekeeperEnv {
        MainGatekeeperEnv(identityReady: identityReady, remoteService: remoteService)
    }

    func fetchDashboardEnv() async -> MainDashboardEnv {
        MainDashboardEnv(identityReady: identityReady, remoteService: remoteService)
    }
}

struct MainDashboardEnv: DashboardEnvProtocol {
    let identityReady: PassthroughSubject<Bool, Never>
    let remoteService: MainRemoteService

    init(identityReady: PassthroughSubject<Bool, Never>,
         remoteService: MainRemoteService) {
        self.identityReady = identityReady
        self.remoteService = remoteService
    }

    func fetchMoviesEnv() -> MainMoviesEnv {
        .init(remoteService: remoteService)
    }
}

struct MainMoviesEnv: MoviesEnvProtocol {
    let remoteService: MainRemoteService

    init(remoteService: MainRemoteService) {
        self.remoteService = remoteService
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not set in config file. Please create Config.xcconfig and add API_KEY = YOUR_API_KEY in it")
        }

        let remoteService = MainRemoteService(apiKey: apiKey)
        let state = WidgetsState()
        let env = MainWidgetsEnv(remoteService: remoteService)
        let store = WidgetsStore(state: state, env: env)
        store.ingest(
            env.identityReady
                .receive(on: RunLoop.main)
                .map(WidgetsMutation.updateIsLoggedIn)
        )
        let mainView = MainView(store: store)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
