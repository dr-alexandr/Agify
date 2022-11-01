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
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = ViewController(viewModel: ViewModel())
        self.window = window
        window.makeKeyAndVisible()
    }
}

