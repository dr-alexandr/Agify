//
//  ViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 31.10.2022.
//

import Foundation
import UIKit

protocol ViewModelProtocol {
    func getAge(name: String,
                onComplete: @escaping (SearchModel) -> Void)
    
    func getName(_ name: String)
    var onCompletion: ((SearchModel) -> Void )? { get set }
    func changeLanguage() -> UIAlertController
}

final class ViewModel: ViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    deinit {
        print("Deallocation \(self)")
    }
    
    var onCompletion: ((SearchModel) -> Void)?
    func getName(_ name: String) {
        getAge(name: name) { [weak self] searchModel in
            guard let self = self else { return }
            self.onCompletion?(searchModel)
        }
    }
    
    func getAge(name: String,
                onComplete: @escaping (SearchModel) -> Void) {
        let endpoint = AgifyAPI.getAgebyName(name: name)
        networkManager.request(endpoint: endpoint) {
            (result: Result<SearchModelDTO, Error>) in
            
            switch result {
            case .success(let response):
                let searchModel = DTOMapper.map(response)
                onComplete(searchModel)
            case .failure(let error):
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func changeLanguage() -> UIAlertController {
        let alertController = UIAlertController (title: String.locString("Change current language"), message: String.locString("Go to Settings?"), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: String.locString("Settings"), style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: String.locString("Cancel"), style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
        return alertController
    }
}






