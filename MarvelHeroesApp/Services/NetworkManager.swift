//
//  NetworkManager.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.02.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchDataWithResult(from url: String, completion: @escaping(Result<Marvel, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
     
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    completion(.failure(.noData))
                    print(error?.localizedDescription ?? " No error description")
                    return
                }
                do {
                    let marvel = try JSONDecoder().decode(Marvel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(marvel))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }.resume()
    }
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }

}


