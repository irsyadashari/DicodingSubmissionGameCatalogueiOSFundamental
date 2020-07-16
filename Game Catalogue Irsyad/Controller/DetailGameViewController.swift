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
    @IBOutlet weak var gameDetailRecommendedSpecs: UITextView!
    
    // Temporary Game Data
    var game : GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         // implementing game's data into UI
           if let result = game {
            gameDetailPoster.image = result.poster
            gameDetailTitle.text = result.title
            gameDetailRating.text = String(result.rating)
            gameDetailReleaseDate.text = result.releasedDate
           }

    }
   
} 
