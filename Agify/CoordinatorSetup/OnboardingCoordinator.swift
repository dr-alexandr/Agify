//
//  OnboardingCoordinator.swift
//  Agify
//
//  Created by Dr.Alexandr on 10.11.2022.
//

import Foundation

class OnboardingCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    var finishFlow: (() -> Void)?
    
    private let router: RouterProtocol
    private let viewControllerFactory: ViewControllerFactory
    
    private func showOnboardingViewController() {
        let onboardingVC = self.viewControllerFactory.createOnboardingController()
        onboardingVC.onboardingCompleted = { [unowned self] in
            self.finishFlow?()
        }
        self.router.setRootModule(onboardingVC, hideBar: true)
    }
    
    override func start() {
        self.showOnboardingViewController()
    }
    
    // MARK: - Init
    
    init(router: RouterProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
    }
    
    deinit {
        print("Deallocation \(self)")
    }
}
