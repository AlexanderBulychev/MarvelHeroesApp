//
//  Heroes.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.02.2022.
//

import Foundation
import CryptoKit

struct Marvel: Decodable {
//    let code: Int?
//    let status: String?
//    let copyright: String?
//    let attributionText: String?
//    let attributionHTML: String?
    let data: DataContainer?
//    let etag: String?
}

struct DataContainer: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
//    let count: Int?
    let results: [Character]?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let description: String?
//    let modified: Date?
//    let resourceURI: String?
//    let urls: [Url]?
    let thumbnail: Image?
//    let comics: ComicList?
//    let stories: StoryList?
//    let events: EventList?
//    let series: SeriesList?
}

//struct Url: Decodable {
//    let type: String?
//    let url: String?
//}

struct Image: Decodable {
    let path: String?
    let format: String?
    
    private enum CodingKeys: String, CodingKey {
        case path = "path"
        case format = "extension"
        }
}

/*
struct ComicList: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}

struct ComicSummary: Decodable {
    let resourceURI: String?
    let name: String?
}

struct StoryList: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummary]?
}

struct StorySummary: Decodable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

struct EventList: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [EventSummary]?
}

struct EventSummary: Decodable {
    let resourceURI: String?
    let name: String?
}

struct SeriesList: Decodable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}

struct SeriesSummary: Decodable {
    let resourceURI: String?
    let name: String?
}
*/
