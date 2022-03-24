//
//  DataManager.swift
//  MarvelHeroesApp
//
//  Created by asbul on 24.03.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    
    private init() {}
    
    func setFavoriteStatus(for heroName: String, with status: Bool) {
        userDefaults.set(status, forKey: heroName)
    }
    
    func getFavoriteStatus(for heroName: String) -> Bool {
        userDefaults.bool(forKey: heroName)
    }
    
}
