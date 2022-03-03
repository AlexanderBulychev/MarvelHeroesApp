//
//  DescriptionViewController.swift
//  MarvelHeroesApp
//
//  Created by asbul on 07.02.2022.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView! {
        didSet {
            heroImageView.layer.cornerRadius = 15
        }
    }
    
    var hero: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = hero.name
        heroDescriptionLabel.text = hero.description
        
        let imageURL = "\(hero.thumbnail?.path ?? "").\(hero.thumbnail?.format ?? "")"
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