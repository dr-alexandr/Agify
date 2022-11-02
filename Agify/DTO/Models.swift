//
//  SearchModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 01.11.2022.
//

import Foundation

// MARK: - Agify SearchModel
struct SearchModelDTO: Decodable {
    let age: Int
    let count: Int
    let name: String
}

struct SearchModel {
    let age: Int
    let count: Int
    let name: String
}

struct DTOMapper {
    static func map(_ dto: SearchModelDTO) -> SearchModel {
        SearchModel(age: dto.age, count: dto.count, name: dto.name)
    }
}

// MARK: - Apify Model

struct ApifyDTO: Decodable {
    let ip: String
}

struct ApifyModel {
    let ip: String
}

struct ApifyMapper {
    static func map (_ dto: ApifyDTO) -> ApifyModel {
        ApifyModel(ip: dto.ip)
    }
}

// MARK: - Info Model

struct InfoDTO: Decodable {
    let ip: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let readme: String
}

struct InfoModel {
    let ip: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let readme: String
    
    func createArr() -> [String] {
        var array: [String] = []
        array.append(ip)
        array.append(city)
        array.append(region)
        array.append(country)
        array.append(loc)
        array.append(org)
        array.append(postal)
        array.append(timezone)
        array.append(readme)
        return array
    }
}

struct InfoMapper {
    static func map(_ dto: InfoDTO) -> InfoModel {
        InfoModel(ip: dto.ip,
                  city: dto.city,
                  region: dto.region,
                  country: dto.country,
                  loc: dto.loc,
                  org: dto.org,
                  postal: dto.postal,
                  timezone: dto.timezone,
                  readme: dto.readme)
    }
}
