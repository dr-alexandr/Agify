//
//  ToDoCoordinator.swift
//  Agify
//
//  Created by Dr.Alexandr on 15.11.2022.
//

import Foundation

final class TodoCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    
    // MARK: - Private methods
    
    private func showToDoViewController() {
        let vc = self.viewControllerFactory.createToDoViewController()
        vc.onBack = { [unowned self] in
            self.finishFlow?()
        }
        self.router.push(vc)
    }
    
    // MARK: - Coordinator
        
        override func start() {
            self.showToDoViewController()
        }
    
    // MARK: - Init
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
    deinit {
        print("Deallocating \(self)")
    }
}
