//
//  NetworkError.swift
//  Agify
//
//  Created by Dr.Alexandr on 01.11.2022.
//

import Foundation

enum NetworkError: String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case noNetwork = "Please check your internet connection."
    case badResponse = "No response, please check your internet."
    case limit = "API rate limit exceeded."
}
