//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameTableView: UITableView!
    var gamesData : [GameData] = []
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager.delegate = self
        gameManager.fetchGames()
        
        gameTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        //           gameTableView.delegate = self
        gameTableView.dataSource = self
        
    }
    
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesData.count
    }
    
    // Set the spacing between sections
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        let game = gamesData[indexPath.row]
        
        let urlPoster = URL(string: game.gamePoster)!
        
        getData(from: urlPoster) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? urlPoster.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                cell.gamePoster.layer.cornerRadius = 16
                cell.gamePoster.image = UIImage(data: data)
                cell.gameTitle.text = game.gameTitle
                cell.gameRating.text = String(game.gameRating)
                cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 16
            }
        }
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
        print(gamesData)
        
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}





