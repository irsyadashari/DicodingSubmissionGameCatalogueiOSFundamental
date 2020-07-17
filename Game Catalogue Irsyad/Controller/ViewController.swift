//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.

import UIKit

//var gamesData : [GameData] = []

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var gameTableView: UITableView!
    var gamesData = [GameData]()
    
//    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            if self.gameTableView.visibleCells.isEmpty{
                 self.gameTableView.reloadData()
            }else{
                self.gameTableView.endUpdates()
            }
           
        }
        
//        gameManager.delegate = self
//        gameManager.fetchGames()
//
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return gamesData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        detail.game = GameModel(
            id: gamesData[indexPath.row].gameId,
            poster: gamesData[indexPath.row].gamePoster,
            title: gamesData[indexPath.row].gameTitle,
            releasedDate: gamesData[indexPath.row].gameReleasedDate,
            rating: String(gamesData[indexPath.row].gameRating))
        
        // Push mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        let game = gamesData[indexPath.row]
        
        cell.gameTitle.text = game.gameTitle
        cell.gameRating.text = String(game.gameRating)
        cell.gamePoster.downloaded(from: game.gamePoster)
        return cell
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let gameURL = "https://api.rawg.io/api/games"
        
        if let url = URL(string: gameURL){
        
        URLSession(configuration: .default).dataTask(with: url){(data, response, error) in
            if error == nil{
                do{
                    let decodedData = try JSONDecoder().decode(GamesModel.self, from: data!)
                    let count = decodedData.count
                    let results = decodedData.results
                    let games = GamesModel(count: count, results: results)
                    
                    for item in games.results{
                        self.gamesData.append(GameData(
                            gameId: item.gameId,
                            gamePoster: item.gamePoster,
                            gameTitle: item.gameTitle,
                            gameReleasedDate: item.gameReleasedDate,
                            gameRating: item.gameRating))
                    }
                    
                    DispatchQueue.main.sync {
                        completed()
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
            
        }
        
    }
    
}

//extension ViewController : UITableViewDataSource, UITableViewDelegate{
//
//    //Data Source
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return gamesData.count
//    }
//
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
//
//        let game = gamesData[indexPath.row]
//
//        let urlPoster = URL(string : game.gamePoster)
//
//
//        getData(from: urlPoster!) { data, response, error in
//            guard let data = data, error == nil else { return }
//
//            DispatchQueue.main.async() {
////                Inflating data at Homepage
//                cell.gameTitle.text = game.gameTitle
//                cell.gameRating.text = String(game.gameRating)
//                cell.gamePoster.image = UIImage(data: data)
//                //styling
//                cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                cell.layer.borderWidth = 1
//                cell.layer.cornerRadius = 16
//                cell.gamePoster.layer.cornerRadius = 16
//
//                print("inflatedgame : \(game.gameTitle)")
//
//            }
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
//        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
//
//        detail.game = GameModel(
//                           id: gamesData[indexPath.row].gameId,
//                           poster: gamesData[indexPath.row].gamePoster,
//                           title: gamesData[indexPath.row].gameTitle,
//                           releasedDate: gamesData[indexPath.row].gameReleasedDate,
//                           rating: String(gamesData[indexPath.row].gameRating))
//
//        // Push mendorong view controller lain
//        self.navigationController?.pushViewController(detail, animated: true)
//    }
//}



//extension ViewController : GameManagerDelegate{
//
//    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
//
//
//        for item in game.results{
//            gamesData.append(item)
//            print("item appended : \(item.gameTitle)")
//
//        }
//
//        DispatchQueue.main.async {
//
//            self.gameTableView.reloadData()
//        }
//
//    }
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//}





