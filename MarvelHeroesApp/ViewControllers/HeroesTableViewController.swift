//
//  HeroesTableViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

import CryptoKit

let marvelUrl = "https://gateway.marvel.com:443/v1/public/characters?"
let publicKey = "eade1da8b900e49b57c24a9f20e69e2f"
let privateKey = "ce9701f28d37990464462fdadf350f994741e442"
let ts = NSDate().timeIntervalSince1970.description
let hash = "\(ts)\(privateKey)\(publicKey)".MD5

let url = "\(marvelUrl)ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"


class HeroesTableViewController: UITableViewController {
    
    private var marvel: Marvel?
    private var fetchingMore = false
    
    var heroesArray = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //marvel?.data?.results?.count ?? 0
        heroesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let hero = heroesArray[indexPath.row]
        
        //let hero = marvel?.data?.results?[indexPath.row]
        cell.configure(with: hero)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
//        let hero = marvel?.data?.results?[indexPath.row]
        
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        descriptionVC.hero = heroesArray[indexPath.row]
        
    }
    
    
    // MARK: - Fetching Data from Network
    private func fetchData() {
        NetworkManager.shared.fetchDataWithResult(from: url) { [weak self] result in
            switch result {
            case .success(let marvel):
//                self?.marvel = marvel
                
                guard let heroes = marvel.data?.results else {
                    return
                }
                
                self?.heroesArray.append(contentsOf: heroes)
                self?.tableView.reloadData()
                //self?.getOffsetFrom(marvel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @discardableResult
    private func getOffsetFrom(_ model: Marvel?) -> Int {
        
        guard
            var offset = model?.data?.offset,
            let limit = model?.data?.limit,
            let total = model?.data?.total
        else { return 0 }
        
        offset += limit
        return total - offset > limit ? offset : (total - offset)
    }
    
    
    private func fetchMoreHeroes(completion: @escaping (Error?) -> Void) {
        if fetchingMore == false {
            fetchingMore = true
            
            let urlForNextHeroes = url + "&offset=" + String(getOffsetFrom(marvel))
            NetworkManager.shared.fetchDataWithResult(from: urlForNextHeroes) { [weak self] result in
                switch result {
                case .success(let marvel):
                    
                    guard let heroes = marvel.data?.results else {
                        return
                    }
                    
                    self?.heroesArray.append(contentsOf: heroes)
                    
//                    self?.marvel = marvel
                    self?.tableView.reloadData()
                    self?.fetchingMore = false
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
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


// MARK: - UIScrollViewDelegate
extension HeroesTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            
            fetchMoreHeroes { error in
                guard let error = error else {
                    self.tableView.reloadData()
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}


