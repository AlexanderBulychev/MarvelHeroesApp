//
//  HeroesTableViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class HeroesTableViewController: UITableViewController {
    
    var heroesArray = [Character]()
    
    private var marvel: Marvel?
    private var fetchingMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        fetchData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath)
        
        let hero = heroesArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = hero.name
        content.image = UIImage(data: <#T##Data#>)
        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Table view delegate
    
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


