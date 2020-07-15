//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var gameTableView: UITableView!
    var gamesData : [GameData] = []
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
           super.viewDidLoad()
         
           gameManager.delegate = self
           gameManager.fetchGames()
           
           gameTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
           gameTableView.delegate = self
           gameTableView.dataSource = self
           
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesData.count
      }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "GameTVCell", for : indexPath) as! GameTVCell
          
          let game = gamesData[indexPath.row]
          cell.gamePoster.image = UIImage(contentsOfFile: game.gamePoster)
          cell.gameTitle.text = game.gameTitle
          cell.gameRating.text = String(game.gameRating)
          print("table telah di inflate")
          return cell
      }
    


}

extension ViewController : GameManagerDelegate{
   
    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
        
        print(game.count)
        
        for item in game.results{
            gamesData.append(item)
        }
        print("Data telah berhasil dimuat")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}



