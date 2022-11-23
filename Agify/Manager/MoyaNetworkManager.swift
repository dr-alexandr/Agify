//
//  MoyaNetworkManager.swift
//  Agify
//
//  Created by Dr.Alexandr on 23.11.2022.
//

import Foundation
import Moya

enum API {
    case getAgebyName(name: String)
    case getInfoByIP(ip: String)
    case getIP
}

// MARK: - Extension
extension API: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getAgebyName:
            return URL(string: "https://api.agify.io")!
        case .getInfoByIP:
            return URL(string: "https://ipinfo.io")!
        case .getIP:
            return URL(string: "https://api.ipify.org")!
        }
    }
    
    var path: String {
        switch self {
        case .getAgebyName:
            return ""
        case .getInfoByIP(ip: let ip):
            return "/\(ip)/geo"
        case .getIP:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAgebyName:
            return .get
        case .getInfoByIP:
            return .get
        case .getIP:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .getAgebyName(let name):
            return .requestParameters(
                parameters: ["name": name], encoding: URLEncoding.queryString)
        case .getInfoByIP:
            return .requestPlain
        case .getIP:
            return .requestParameters(parameters: ["format":"json"], encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]? {
        return [:]
    }
}

// MARK: - NetworkManager Class

protocol NetworkManagerProtocol {
    var provider: MoyaProvider<API> { get }
    
    func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void) {
        
        provider.request(endpoint) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    DispatchQueue.main.async {
                        completion(.success(results))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    deinit {
        print("Deallocation \(self)")
    }
}
