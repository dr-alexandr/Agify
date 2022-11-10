//
//  LaunchInstructor.swift
//  Agify
//
//  Created by Dr.Alexandr on 10.11.2022.
//

import Foundation

fileprivate var onboardingWasShown = false

enum LaunchInstructor {
    
    case main
    case onboarding
    
    // MARK: - Public methods
    
    static func configure( tutorialWasShown: Bool = onboardingWasShown) -> LaunchInstructor {
        switch (tutorialWasShown) {
            case (false): return .onboarding
            case (true): return .main
        }
    }
}
