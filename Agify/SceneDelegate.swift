//
//  SceneDelegate.swift
//  Agify
//
//  Created by Dr.Alexandr on 28.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: ApplicationCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 1
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        // 2
        let appWindow = UIWindow(windowScene: windowScene)
        
        // 3
        let navController = UINavigationController()
        appCoordinator = ApplicationCoordinator(router: Router(rootController: navController), coordinatorFactory: CoordinatorFactory())
        appCoordinator?.start()

        // 4
        appWindow.rootViewController = navController
        appWindow.makeKeyAndVisible()
        
        // 5
        window = appWindow
    }
    
}

