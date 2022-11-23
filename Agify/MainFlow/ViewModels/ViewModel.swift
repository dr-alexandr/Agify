//
//  ViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 31.10.2022.
//

import Foundation

protocol ViewModelProtocol {
    func getAge(name: String,
                onComplete: @escaping (SearchModel) -> Void)
    
    func getName(_ name: String)
    var onCompletion: ((SearchModel) -> Void )? { get set }
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
        let endpoint = API.getAgebyName(name: name)
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
}






