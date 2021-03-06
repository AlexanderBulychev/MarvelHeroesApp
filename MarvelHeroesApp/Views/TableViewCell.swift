//
//  TableViewCell.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var heroName: UILabel!
    @IBOutlet weak var heroImageView: HeroImageView! {
        didSet {
            heroImageView.contentMode = .scaleAspectFill
            heroImageView.clipsToBounds = true
            heroImageView.layer.cornerRadius = heroImageView.frame.height / 2
            heroImageView.backgroundColor = .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.image = nil
        heroImageView.image = UIImage()
    }
    
    func configure(with hero: Character) {
        heroName.text = hero.name
        
        let imageLink = "\(hero.thumbnail?.path ?? "").\(hero.thumbnail?.format ?? "")"
        heroImageView.fetchImage(from: imageLink)
    }
}
