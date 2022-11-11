//
//  LaunchInstructor.swift
//  Agify
//
//  Created by Dr.Alexandr on 10.11.2022.
//

import Foundation


enum LaunchInstructor {
    
    case login
    case main
    case onboarding
    
    // MARK: - Public methods
    
    static func configure(loggedIn: Bool = UserDefaults.standard.bool(forKey: "LoggedIn"),
                          welcomeScreenWasShown: Bool = UserDefaults.standard.bool(forKey: "welcomeScreenWasShown")) -> LaunchInstructor {
        switch (loggedIn, welcomeScreenWasShown) {
            case (true, true): return .main
            case (false, _): return .login
            case (true, false): return .onboarding
        }
    }
}
