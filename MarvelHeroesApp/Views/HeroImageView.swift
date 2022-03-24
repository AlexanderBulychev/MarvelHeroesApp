//
//  HeroImageView.swift
//  MarvelHeroesApp
//
//  Created by asbul on 23.03.2022.
//

import UIKit

class HeroImageView: UIImageView {
    
    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            image = #imageLiteral(resourceName: "defaultImageHeroes")
            return
        }
        
        // Use image from cache
        if let cachedImage = getImageCachedImage(from: imageURL) {
            image = cachedImage
            return
        }
        
        // Download image from url
        NetworkManager.shared.fetchDataForImageViewClass(from: imageURL) { data, response in
            // Save image to cash
            self.saveDataToCash(with: data, and: response)
            if imageURL.lastPathComponent == response.url?.lastPathComponent {
                print("Image from url: ", imageURL.lastPathComponent)
                self.image = UIImage(data: data)
            }
        }
    }
    
    private func saveDataToCash(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getImageCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        guard url.lastPathComponent == cachedResponse.response.url?.lastPathComponent else { return nil }
        print("Image from cache: ", url.lastPathComponent)
        return UIImage(data: cachedResponse.data)
    }
}
