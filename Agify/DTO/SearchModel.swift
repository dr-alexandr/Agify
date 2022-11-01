//
//  SearchModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 01.11.2022.
//

import Foundation

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
