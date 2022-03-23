//
//  HeroesTableViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit
import Alamofire

class HeroesTableViewController: UITableViewController {
    
    private var marvel: Marvel?
    private var heroesArray = [Character]()
    
    // MARK: - Ancillary properties for fetching more Heroes
    private var offset = 0
    private var limit = 0
    private var fetchingMore = false

    // MARK: - Ancillary properties for search
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredHeroes = [Character]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var spinnerView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        setupSearchController()
        showSpinner(in: tableView)
        setupRefreshControl()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredHeroes.count : heroesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath) as! TableViewCell
        let hero = isFiltering ? filteredHeroes[indexPath.row] : heroesArray[indexPath.row]
        cell.configure(with: hero)
        spinnerView.stopAnimating()
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let hero = isFiltering ? filteredHeroes[indexPath.row] : heroesArray[indexPath.row]
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        descriptionVC.hero = hero
    }
    
    // MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find your favorite hero"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func showSpinner(in view: UITableView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.style = .large
        spinnerView.color = .darkGray
        spinnerView.startAnimating()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        
        view.addSubview(spinnerView)
    }
}

// MARK: - Fetching Data from Network
extension HeroesTableViewController {
    
    private func getOffset() -> Int {
        offset += limit
        return offset
    }
    
    private func fetchHeroes() {
        if fetchingMore == false {
            fetchingMore = true
            
            let urlForNextHeroes = MarvelApi.shared.url + "&offset=" + String(getOffset())
            NetworkManager.shared.fetchDataWithAlamofire(from: urlForNextHeroes) { [weak self] result in
                switch result {
                case .success(let marvel):
                    guard let heroes = marvel.data?.results,
                          let offset = marvel.data?.offset,
                          let limit = marvel.data?.limit
                    else { return }
                    self?.heroesArray.append(contentsOf: heroes)
                    self?.offset = offset
                    self?.limit = limit
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
            fetchHeroes()
        }
    }
    
    // MARK: - UIRefreshControl
    @objc private func downloadHeroes() {
        let urlForNextHeroes = MarvelApi.shared.url + "&offset=" + String(getOffset())
        NetworkManager.shared.fetchDataWithResult(from: urlForNextHeroes) { [weak self] result in
            switch result {
            case .success(let marvel):
                guard let heroes = marvel.data?.results,
                      let offset = marvel.data?.offset,
                      let limit = marvel.data?.limit
                else { return }
                self?.heroesArray.append(contentsOf: heroes)
                self?.offset = offset
                self?.limit = limit
                self?.tableView.reloadData()
                if self?.refreshControl != nil {
                    self?.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh the list of heroes")
        refreshControl?.addTarget(self, action: #selector(downloadHeroes), for: .valueChanged)
    }
}

// MARK: - UISearchResultUpdating Delegate
extension HeroesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredHeroes = heroesArray.filter { hero in
            hero.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
}

