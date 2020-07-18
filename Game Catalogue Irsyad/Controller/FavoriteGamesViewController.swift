//
//  FavoriteGamesViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class FavoriteGamesViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    
    var gamesData : [GameData]?
    var favoriteGamesData : [GameData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let gamesData = gamesData{
            
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
