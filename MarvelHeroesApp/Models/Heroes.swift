//
//  Heroes.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.02.2022.
//

import Foundation

struct Marvel: Decodable {
    let data: DataContainer?
}

struct DataContainer: Decodable {
    let offset: Int?
    let limit: Int?
    let results: [Character]?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Image?
    let series: SeriesList?
}

struct Image: Decodable {
    let path: String?
    let format: String?
    
    private enum CodingKeys: String, CodingKey {
        case path = "path"
        case format = "extension"
        }
}

struct SeriesList: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummary]?
}

struct SeriesSummary: Decodable {
    let resourceURI: String?
    let name: String?
}
