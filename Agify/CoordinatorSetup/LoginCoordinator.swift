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
//        loginVC.onRegister = { [unowned self] in
//            self.showRegisterViewController()
//        }
//        loginVC.onChangePassword = { [unowned self, unowned loginVC] in
//            self.showForgetPassword(module: loginVC)
//        }
        self.router.setRootModule(loginVC, hideBar: true)
    }
    
//    private func showRegisterViewController() {
//        let registerVC = self.viewControllerFactory.instantiateRegisterViewController()
//        registerVC.onBack = { [unowned self] in
//            self.router.popModule()
//        }
//        registerVC.onRegister = { [unowned self] in
//            self.router.popModule()
//        }
//        self.router.push(registerVC)
//    }
    
    // MARK: - Coordinator
    
    override func start() {
        self.showLoginViewController()
    }
    
    // MARK: - Init
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
}
