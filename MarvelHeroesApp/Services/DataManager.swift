//
//  DataManager.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.03.2022.
//

import Foundation
import CryptoKit

let marvelUrl = "https://gateway.marvel.com:443/v1/public/characters?"
let publicKey = "eade1da8b900e49b57c24a9f20e69e2f"
let privateKey = "ce9701f28d37990464462fdadf350f994741e442"
let ts = NSDate().timeIntervalSince1970.description
let hash = "\(ts)\(privateKey)\(publicKey)".MD5

let url = "\(marvelUrl)ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"

extension String {
    var MD5: String {
        return Insecure
            .MD5
            .hash(data: self.data(using: .utf8) ?? Data())
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
