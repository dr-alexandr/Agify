//
//  CoordinatorFactory.swift
//  Agify
//
//  Created by Dr.Alexandr on 03.11.2022.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    
    func makeMainCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> MainCoordinator
    
    func makeOnboardingCoordinatorBox(router: RouterProtocol, viewControllerFactory: ViewControllerFactory) -> OnboardingCoordinator
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - CoordinatorFactoryProtocol
    
    func makeMainCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> MainCoordinator {
        let coordinator = MainCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }
    
    func makeOnboardingCoordinatorBox(router: RouterProtocol, viewControllerFactory: ViewControllerFactory) -> OnboardingCoordinator {
        let coordinator = OnboardingCoordinator(router: router, viewControllerFactory: viewControllerFactory)
        return coordinator
    }
}