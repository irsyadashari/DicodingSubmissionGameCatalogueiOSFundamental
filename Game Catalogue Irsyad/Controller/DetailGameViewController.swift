//
//  DetailGameViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit
import Nuke
class DetailGameViewController: UIViewController {
    @IBOutlet weak var gameDetailPoster: UIImageView!
    @IBOutlet weak var gameDetailTitle: UILabel!
    @IBOutlet weak var gameDetailRating: UILabel!
    @IBOutlet weak var gameDetailReleaseDate: UILabel!
    
    // Temporary Game Data
    var game : GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // implementing game's data into UI
        if let result = game {
            
            // This line doesn't change
            let url = URL(string : result.poster)!
            
            // 2
            let request = ImageRequest(
                url: url,
                targetSize: CGSize(width: 414, height: 409),
                contentMode: .aspectFill)
            
            Nuke.loadImage(with: request, into: gameDetailPoster)
            self.gameDetailTitle.text = result.title
            self.gameDetailRating.text = String(result.rating)
            self.gameDetailReleaseDate.text = result.releasedDate
        }
    }
}


