//
//  SceneDelegate.swift
//  Agify
//
//  Created by Dr.Alexandr on 28.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: ViewController(viewModel: ViewModel(networkManager: NetworkManager())))
        window.makeKeyAndVisible()
        self.window = window
    }
}

