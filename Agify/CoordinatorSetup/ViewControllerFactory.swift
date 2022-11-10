//
//  ViewControllerFactory.swift
//  Agify
//
//  Created by Dr.Alexandr on 03.11.2022.
//

import Foundation

class ViewControllerFactory {
    
    func createViewController() -> ViewController {
        let vc = ViewController(viewModel: ViewModel(networkManager: NetworkManager()))
        return vc
    }
    
    func createInfoViewController() -> InfoViewCotroller {
        let vc = InfoViewCotroller(infoViewModel: InfoViewModel(networkManager: NetworkManager()))
        return vc
    }
    
    func createOnboardingController() -> OnboardingViewController {
        let vc = OnboardingViewController()
        return vc
    }
    
}