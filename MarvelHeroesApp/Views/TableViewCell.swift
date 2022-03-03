//
//  TableViewCell.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var heroName: UILabel!
    @IBOutlet weak var heroImageView: UIImageView! {
        didSet {
            heroImageView.contentMode = .scaleAspectFill
            heroImageView.clipsToBounds = true
            heroImageView.layer.cornerRadius = heroImageView.frame.height / 2
            heroImageView.backgroundColor = .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.image = UIImage()
    }
    
    func configure(with hero: Character?) {
        heroName.text = hero?.name ?? ""
        
        let imageURL = "\(hero?.thumbnail?.path ?? "").\(hero?.thumbnail?.format ?? "")"
        NetworkManager.shared.fetchImage(from: imageURL) { result in
            switch result {
            case .success(let data):
                self.heroImageView.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
