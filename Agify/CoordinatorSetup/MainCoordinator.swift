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
        vc.goToDo = { [unowned self] in
            self.showToDoList()
        }
        self.router.setRootModule(vc, hideBar: true)
    }
    
    private func showInfoViewController() {
        let vc = self.viewControllerFactory.createInfoViewController()
        vc.goBack = { [unowned self] in
            self.router.popModule()
        }
        vc.logout = { [unowned self] in
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            self.finishFlow?()
        }
        self.router.push(vc)
    }
    
    private func showToDoList() {
        let coordinator = self.coordinatorFactory.makeToDoCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popModule()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    // MARK: - Coordinator
    
    override func start() {
        UserDefaults.standard.set(true, forKey: "LoggedIn")
        self.showViewController()
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
