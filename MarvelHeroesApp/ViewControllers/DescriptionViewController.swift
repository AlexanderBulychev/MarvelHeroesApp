//
//  DescriptionViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var heroImageView: HeroImageView! {
        didSet {
            heroImageView.contentMode = .scaleAspectFill
            heroImageView.layer.cornerRadius = 15
            }
        }
    @IBOutlet weak var heroSeries: UITableView!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    var hero: Character!
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStatusForFavoriteButton()
        setupUI()
    }
    
    @IBAction func isFavoriteButtonPressed(_ sender: Any) {
        isFavorite.toggle()
        setStatusForFavoriteButton()
        guard let heroName = hero.name else { return }
        DataManager.shared.setFavoriteStatus(for: heroName, with: isFavorite)
    }
    
    private func setupUI() {
        title = hero.name
        if hero.description != "" {
        heroDescriptionLabel.text = hero.description
        } else {
            heroDescriptionLabel.textColor = .lightGray
            heroDescriptionLabel.text = "Sorry, but we don't have information about this hero"
        }
        
        let imageLink = "\(hero.thumbnail?.path ?? "").\(hero.thumbnail?.format ?? "")"
        heroImageView.fetchImage(from: imageLink)
        
        setStatusForFavoriteButton()
    }
    
    private func setStatusForFavoriteButton() {
        isFavoriteButton.tintColor = isFavorite ? .systemYellow : .white
    }
    
    private func loadStatusForFavoriteButton() {
        guard let heroName = hero.name else { return }
        isFavorite = DataManager.shared.getFavoriteStatus(for: heroName)
    }
}

// MARK: - TableView Data Source
extension DescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hero.series?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Series", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let seriesName = hero.series?.items?[indexPath.row].name {
            content.text = seriesName
            content.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .light)
        }
        cell.contentConfiguration = content
        return cell
    }
}

