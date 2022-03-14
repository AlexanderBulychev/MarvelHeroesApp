//
//  DataManager.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.03.2022.
//

import Foundation
import CryptoKit

class MarvelApi {
    static let shared = MarvelApi()
    var url: String {
        "\(marvelUrl)ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    private let marvelUrl = "https://gateway.marvel.com:443/v1/public/characters?"
    private let publicKey = "eade1da8b900e49b57c24a9f20e69e2f"
    private let privateKey = "ce9701f28d37990464462fdadf350f994741e442"
    private let ts = NSDate().timeIntervalSince1970.description
    private var hash: String {
    (ts + privateKey + publicKey).MD5
    }
        
    init() {}
}

extension String {
    var MD5: String {
        return Insecure
            .MD5
            .hash(data: self.data(using: .utf8) ?? Data())
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}

