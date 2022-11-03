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
    func setData(_ infoModel: InfoModel)
    func getCellTitle(by indexPath: IndexPath) -> String
    
    var infoTable: [String] { get set }
    var onCompletion: ((InfoModel) -> Void )? { get set }
}

final class InfoViewModel: InfoViewModelProtocol {
    
    var infoTable: [String] = [ "IP : ", "City : ", "Region : ",
                                "Country : ", "Loc : ", "Org : ",
                                "Postal : ", "Timezone : ", "Readme : " ]
    var onCompletion: ((InfoModel) -> Void)?
    
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
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
    
    func setData(_ infoModel: InfoModel) {
        let array = infoModel.createArr()
        for n in 0..<infoTable.count {
            self.infoTable[n] += array[n]
        }
    }
    
    func getCellTitle(by indexPath: IndexPath) -> String {
        return infoTable[indexPath.row]
    }
}
