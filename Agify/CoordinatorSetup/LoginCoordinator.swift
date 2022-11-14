//
//  LoginCoordinator.swift
//  Agify
//
//  Created by Dr.Alexandr on 11.11.2022.
//

import Foundation

final class LoginCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    // MARK: - CoordinatorFinishOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    
    
    // MARK: - Private methods
    
    private func showLoginViewController() {
        let loginVC = self.viewControllerFactory.createLoginViewController()
        loginVC.login = { [unowned self] in
            self.finishFlow?()
        }
        loginVC.goToRegisterPage = { [unowned self] in
            self.showRegisterViewController()
        }
        self.router.setRootModule(loginVC, hideBar: true)
    }
    
    private func showRegisterViewController() {
        let registerVC = self.viewControllerFactory.createRegisterViewController()
        registerVC.goToLoginPage = { [unowned self] in
            self.showLoginViewController()
        }
        registerVC.register = { [unowned self] in
            self.finishFlow?()
        }
        self.router.setRootModule(registerVC, hideBar: true)
    }
    
    // MARK: - Coordinator
    
    override func start() {
        self.showLoginViewController()
    }
    
    deinit {
        print("Deallocation \(self)")
    }
    
    // MARK: - Init
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
}
