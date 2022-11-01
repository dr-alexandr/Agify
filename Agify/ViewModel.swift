//
//  ViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 31.10.2022.
//

import Foundation

protocol ViewModelProtocol {
    func getAge(name: String,
                onComplete: @escaping (String) -> Void)
    
    func getName(_ name: String)
    var onCompletion: ((String) -> Void )? { get set }
}

final class ViewModel: ViewModelProtocol {
    
    var onCompletion: ((String) -> Void)?
    func getName(_ name: String) {
        getAge(name: name) { [weak self] name in
            guard let self = self else { return }
            self.onCompletion?(name)
        }
    }
    
    func getAge(name: String,
                onComplete: @escaping (String) -> Void) {
        let endpoint = AgifyAPI.getAgebyName(name: name)
        NetworkManager.request(endpoint: endpoint) {
            (result: Result<SearchModel, Error>) in
            
            switch result {
            case .success(let response):
                print(response.age)
                DispatchQueue.main.async {
                    onComplete("\(response.age)")
                }
            case .failure(let error):
                print("Smthng went wrng \(error)")
            }
        }
    }
}






