//
//  DetailGameViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var gameDetailPoster: UIImageView!
    @IBOutlet weak var gameDetailTitle: UILabel!
    @IBOutlet weak var gameDetailRating: UILabel!
    @IBOutlet weak var gameDetailReleaseDate: UILabel!
    
    // Temporary Game Data
    var game : GameModel?
    
    var gamePoster : UIImage = UIImage(imageLiteralResourceName: "loading-image-cardview-game-poster")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // implementing game's data into UI
           if let result = game {
        
            self.gamePoster = result.poster
            self.gameDetailPoster.image = result.poster
            self.gameDetailTitle.text = result.title
            self.gameDetailRating.text = String(result.rating)
            self.gameDetailReleaseDate.text = result.releasedDate
           }

    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
   
} 
