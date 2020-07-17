//
//  ViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 06/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.

import UIKit
import Nuke

class ViewController: UIViewController {
    
    @IBOutlet var gameTableView: UITableView!
    var gamesData = [GameData]()
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager.delegate = self
        gameManager.fetchGames()
        
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFill,
            failure: .scaleAspectFill,
            placeholder: .scaleAspectFill)
        
        ImageLoadingOptions.shared.contentModes = contentModes
        ImageLoadingOptions.shared.placeholder = UIImage(named: "loading-image-cardview-game-poster")
        ImageLoadingOptions.shared.failureImage = UIImage(named: "fail-to-load-image")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
        
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            // 2
            let dataCache = try! DataCache(name: "com.irsyadashari.Game-Catalogue.datacache")
            
            // 3
            dataCache.sizeLimit = 200 * 1024 * 1024
            
            // 4
            $0.dataCache = dataCache
        }
        
        // 5
        ImagePipeline.shared = pipeline
        
        
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
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
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    //Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesData.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = gameTableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        let game = gamesData[indexPath.row]
        
        // This line doesn't change
        let url = URL(string : game.gamePoster)
        let request = ImageRequest(
            url: url!,
            targetSize: CGSize(width: 280, height: 170),
            contentMode: .aspectFill)
        
        let options = ImageLoadingOptions(
          placeholder: UIImage(named: "loading-image-cardview-game-poster"),
          transition: .fadeIn(duration: 0.5)
        )
        
        Nuke.loadImage(with: request, options: options, into: cell.gamePoster)
        cell.gameTitle.text = game.gameTitle
        cell.gameRating.text = String(game.gameRating)
        
        return cell
    }
    
}

extension ViewController : GameManagerDelegate{
    
    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
        for item in game.results{
            gamesData.append(item)
            print("item appended : \(item.gameTitle)")
        }
         DispatchQueue.main.async() {
            self.gameTableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}









