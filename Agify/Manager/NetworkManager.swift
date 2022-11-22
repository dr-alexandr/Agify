//
//  NetworkManager.swift
//  Agify
//
//  Created by Dr.Alexandr on 31.10.2022.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}

protocol API {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

// MARK: - ApifyAPI
enum ApifyAPI: API {
    
    case getIP
    
    var scheme:HTTPScheme {
        switch self {
        case .getIP:
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        case .getIP:
            return "api.ipify.org"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getIP:
            let params = [
                URLQueryItem(name: "format", value: "json")
            ]
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getIP:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getIP:
            return ""
        }
    }
}

// MARK: - InfoApi
enum InfoApi: API {
    
    case getInfoByIP(ip: String)
    
    var scheme: HTTPScheme {
        switch self {
        case .getInfoByIP:
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        case .getInfoByIP:
            return "ipinfo.io"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getInfoByIP:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getInfoByIP(let ip):
            return "/\(ip)/geo"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getInfoByIP:
            return []
        }
    }
    
}

// MARK: - AgifyAPI
enum AgifyAPI: API {
    
    case getAgebyName(name: String)
    
    var scheme: HTTPScheme {
        switch self {
        case .getAgebyName:
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        case .getAgebyName:
            return "api.agify.io"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getAgebyName(let name):
            let params = [
                URLQueryItem(name: "name", value: name)
            ]
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAgebyName:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAgebyName:
            return ""
        }
    }
}

// MARK: - BuildURL Func
private func buildURL(endpoint: API) -> URLComponents {
    var components = URLComponents()
    components.scheme = endpoint.scheme.rawValue
    components.host = endpoint.baseURL
    components.queryItems = endpoint.parameters
    components.path = endpoint.path
    return components
}

// MARK: - NetworkManager Class

protocol NetworkManagerProtocol {
    func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            completion(.failure(NetworkError.outdated))
            return
        }
        AF.request(url).validate().responseData { (data) in
            switch data.result {
            case .success(_):
                let decoder = JSONDecoder()
                if let jsonData = data.data {
                    let result = try! decoder.decode(T.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                }
                break
            case .failure(_):
                completion(.failure(NetworkError.noData))
                break
            }
        }
    }
    
    deinit {
        print("Deallocation \(self)")
    }
}
