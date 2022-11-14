//
//  ApplicationCoordinator.swift
//  Agify
//
//  Created by Dr.Alexandr on 04.11.2022.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    // MARK: - Vars & Lets
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private let viewControllerFactory: ViewControllerFactory = ViewControllerFactory()
    private var launchInstructor = LaunchInstructor.configure()
    
    // MARK: - Coordinator
    
    override func start() {
        switch launchInstructor {
            case .onboarding: runOnboardingFlow()
            case .main: runMainFlow()
            case .login: runLoginFlow()
        }
    }
    
    deinit {
        print("Deallocation \(self)")
    }
    
    // MARK: - Private methods
    
    private func runLoginFlow() {
        let coordinator = self.coordinatorFactory.makeLoginCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            self.launchInstructor = LaunchInstructor.configure()
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
        
    }
    
    private func runMainFlow() {
        let coordinator = self.coordinatorFactory.makeMainCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            self.launchInstructor = LaunchInstructor.configure()
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runOnboardingFlow() {
        let coordinator = self.coordinatorFactory.makeOnboardingCoordinatorBox(router: self.router, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            UserDefaults.standard.set(true, forKey: "welcomeScreenWasShown")
            self.launchInstructor = LaunchInstructor.configure()
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    // MARK: - Init
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
}
