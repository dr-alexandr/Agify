//
//  MainCoordinator.swift
//  Agify
//
//  Created by Dr.Alexandr on 03.11.2022.
//

import Foundation

final class MainCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    
    // MARK: - Private methods
    
    private func showViewController() {
        let vc = viewControllerFactory.createViewController()
        vc.goToInfo = { [unowned self] in
            self.showInfoViewController()
        }
        self.router.setRootModule(vc, hideBar: true)
    }
    
    private func showInfoViewController() {
        let vc = self.viewControllerFactory.createInfoViewController()
//        vc.onBack = { [unowned self] in
//            self.router.popModule()
//        }
        self.router.push(vc)
    }
    
    // MARK: - Coordinator
    
    override func start() {
        self.showViewController()
    }
    
    // MARK: - Init
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
}
