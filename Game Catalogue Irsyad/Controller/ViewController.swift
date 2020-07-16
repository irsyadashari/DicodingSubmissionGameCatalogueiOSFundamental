//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameTableView: UITableView!
    var gamesData : [GameData] = []
    
    var gamePosterDownloaded : [UIImage] = []
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager.delegate = self
        gameManager.fetchGames()
        
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesData.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        let game = gamesData[indexPath.row]
        
        let urlPoster = URL(string: game.gamePoster)!
        
        cell.gameTitle.text = game.gameTitle
        cell.gameRating.text = String(game.gameRating)
        
        //styling
        cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 16
        cell.gamePoster.layer.cornerRadius = 16
        
        getData(from: urlPoster) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                //Inflating data at Homepage
                cell.gamePoster.image = UIImage(data: data)
            }
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        // Mengirim data hero
//        detail.game = gamesData[(indexPath.row)]

        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
     }
 }

extension ViewController : GameManagerDelegate{
    
    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
        
        for item in game.results{
            gamesData.append(item)
        }
        
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
            print("data di reload")
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}





