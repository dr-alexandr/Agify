//
//  InfoViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 02.11.2022.
//

import Foundation

protocol InfoViewModelProtocol {
    func getInfo(_ ip: String)
    func getIP()
    func setData(_ infoModel: InfoModel)
    func getCellTitle(by indexPath: IndexPath) -> String
    
    var infoTable: [String] { get set }
    var onCompletion: (() -> Void )? { get set }
    var numberOfRows: Int { get }
}

final class InfoViewModel: InfoViewModelProtocol {
    
    var infoTable: [String] = [ "IP : ", "City : ", "Region : ",
                                "Country : ", "Loc : ", "Org : ",
                                "Postal : ", "Timezone : ", "Readme : " ]
    var numberOfRows: Int {
        infoTable.count
    }
    var onCompletion: (() -> Void)?
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getIP() {
        let endpoint = ApifyAPI.getIP
        networkManager.request(endpoint: endpoint) { (result: Result<ApifyDTO, Error>) in
            switch result {
            case .success(let response):
                let apifyModel = ApifyMapper.map(response)
                self.getInfo(apifyModel.ip)
            case .failure(let error):
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func getInfo(_ ip: String) {
        let endpoint = InfoApi.getInfoByIP(ip: ip)
        networkManager.request(endpoint: endpoint) { (result: Result<InfoDTO,Error>) in
            switch result {
            case .success(let response):
                let infoModel = InfoMapper.map(response)
                self.setData(infoModel)
                self.onCompletion?()
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
