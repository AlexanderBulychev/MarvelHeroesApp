//
//  NetworkManager.swift
//  MarvelHeroesApp
//
//  Created by asbul on 03.02.2022.
//

import Foundation
import Alamofire

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
    
    func fetchDataWithAlamofire(from url: String, completion: @escaping(Result<Marvel, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: Marvel.self) { dataResponse in
                switch dataResponse.result {
                case .success(let marvel):
                    completion(.success(marvel))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
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
    
    func fetchDataForImageViewClass(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        AF.request(url)
            .validate()
            .response { dataResponse in
                guard let data = dataResponse.data, let response = dataResponse.response else {
                    print(dataResponse.error ?? "No error")
                    return
                }
                completion(data, response)
            }
    }
    
}

