//
//  DescriptionViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit
import AlamofireImage

class DescriptionViewController: UIViewController {

    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView! {
        didSet {
            heroImageView.contentMode = .scaleAspectFill
            heroImageView.layer.cornerRadius = 15
            }
        }
    @IBOutlet weak var heroSeries: UITableView!
    
    var hero: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        guard let imageURL = URL(string: imageLink) else { return }
        heroImageView.af.setImage(withURL: imageURL)
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

