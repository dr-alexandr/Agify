//
//  NetworkManager.swift
//  Agify
//
//  Created by Dr.Alexandr on 31.10.2022.
//

import Foundation

struct SearchModel: Decodable {
    let age: Int
    let count: Int
    let name: String
}

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
}

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
}

final class NetworkManager {
    private class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.queryItems = endpoint.parameters
        return components
    }
    class func request<T: Decodable>(endpoint: API,
                                     completion: @escaping (Result<T, Error>)
                                        -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            print("URL creation error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error: \(error)")
                return
            }
            guard response != nil, let data = data else {
                return
            }
            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "com.AryamanSharda",
                                    code: 200,
                                    userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
