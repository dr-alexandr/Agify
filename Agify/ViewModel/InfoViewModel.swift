//
//  InfoViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 02.11.2022.
//

import Foundation

protocol InfoViewModelProtocol {
    func getInfo(_ ip: String, onComplete: @escaping (InfoModel) -> Void)
    func getIP()
    
    var onCompletion: ((InfoModel) -> Void )? { get set }
}

final class InfoViewModel: InfoViewModelProtocol {
    var onCompletion: ((InfoModel) -> Void)?
    
    let networkManager = NetworkManager()
    
    func getIP() {
        let endpoint = ApifyAPI.getIP
        networkManager.request(endpoint: endpoint) { (result: Result<ApifyDTO, Error>) in
            switch result {
            case .success(let response):
                let apifyModel = ApifyMapper.map(response)
                self.getInfo(apifyModel.ip) { [weak self] infoModel in
                    guard let self = self else { return }
                    self.onCompletion?(infoModel)
                }
            case .failure(let error):
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func getInfo(_ ip: String, onComplete: @escaping (InfoModel) -> Void) {
        let endpoint = InfoApi.getInfoByIP(ip: ip)
        networkManager.request(endpoint: endpoint) { (result: Result<InfoDTO,Error>) in
            switch result {
            case .success(let response):
                let infoModel = InfoMapper.map(response)
                onComplete(infoModel)
            case .failure(let error):
                Log.e(error.localizedDescription)
            }
        }
    }
}
