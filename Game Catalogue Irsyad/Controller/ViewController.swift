//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.

import UIKit

enum DownloadState {
    case new, downloaded, failed
}



class Game {
    let id : Int
    let title : String
    let rating : Float
    var poster : UIImage
    let releaseDate : String
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(id: Int,title: String, poster: UIImage, rating : Float, releaseDate : String) {
        self.id = id
        self.title = title
        self.poster = poster
        self.rating = rating
        self.releaseDate = releaseDate
    }
    
}

var gamesData : [GameData] = []
var games: [Game] = []


class ViewController: UIViewController {
    
    @IBOutlet var gameTableView: UITableView!
    
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

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesData.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        let game = gamesData[indexPath.row]
        
        let urlPoster = URL(string : game.gamePoster)
        
        
        getData(from: urlPoster!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                //Inflating data at Homepage
                cell.gameTitle.text = game.gameTitle
                cell.gameRating.text = String(game.gameRating)
                cell.gamePoster.image = UIImage(data: data)
                //styling
                cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 16
                cell.gamePoster.layer.cornerRadius = 16
                
                if(game.gameId  == games[indexPath.row].id){
                    games[indexPath.row].poster = UIImage(data: data)!
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
            
        detail.game = GameModel(
                           id: games[indexPath.row].id,
                           poster: games[indexPath.row].poster,
                           title: games[indexPath.row].title,
                           releasedDate: games[indexPath.row].releaseDate,
                           rating: String(games[indexPath.row].rating))
     
        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension ViewController : GameManagerDelegate{
    
    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
        
        for item in game.results{
            gamesData.append(item)
            
            games.append(Game(
                id: item.gameId,
                title: item.gameTitle,
                poster: UIImage(imageLiteralResourceName: "loading-image-cardview-game-poster"),
                rating : item.gameRating,
                releaseDate : item.gameReleasedDate
            ))
        }
        
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}





