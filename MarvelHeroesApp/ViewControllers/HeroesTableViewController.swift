//
//  HeroesTableViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class HeroesTableViewController: UITableViewController {
    
    private var marvel: Marvel?
    private var heroesArray = [Character]()
    
    // MARK: - Ancillary values
    private var offset = 0
    private var limit = 0
    private var fetchingMore = false
    // private var offsetModel: OffsetModel?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath) as! TableViewCell
        let hero = heroesArray[indexPath.row]
        cell.configure(with: hero)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        descriptionVC.hero = heroesArray[indexPath.row]
    }
    
    
    // MARK: - Fetching Data from Network
    private func fetchData() {
        NetworkManager.shared.fetchDataWithResult(from: MarvelApi.shared.url) { [weak self] result in
            switch result {
            case .success(let marvel):
                guard let heroes = marvel.data?.results else {
                    return
                }
                self?.marvel = marvel
                self?.offset = marvel.data?.offset ?? 0
                self?.limit = marvel.data?.limit ?? 0
                self?.heroesArray.append(contentsOf: heroes)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
        
}

extension HeroesTableViewController {
    
    //MARK: - Fetching More Data from Network
    private func getOffset() -> Int {
        offset += limit
        return offset
    }
    
    private func fetchMoreHeroes() {
        if fetchingMore == false {
            fetchingMore = true
            
            let urlForNextHeroes = MarvelApi.shared.url + "&offset=" + String(getOffset())
            NetworkManager.shared.fetchDataWithResult(from: urlForNextHeroes) { [weak self] result in
                switch result {
                case .success(let marvel):
                    guard let heroes = marvel.data?.results,
                          let offset = marvel.data?.offset
                    else { return }
                    self?.heroesArray.append(contentsOf: heroes)
                    self?.offset = offset
                    self?.tableView.reloadData()
                    self?.fetchingMore = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            fetchMoreHeroes()
        }
    }
}

