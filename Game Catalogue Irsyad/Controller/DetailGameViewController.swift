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
    @IBOutlet weak var gameDescription: UITextView!
    
    // Temporary Game Data
    var game : GameModel?
    var gameDownloader = GameDownloaderManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameDownloader.delegate = self
       
        
        // implementing game's data into UI
        if let result = game {
            let url = URL(string : result.poster)!
            let request = ImageRequest(
                url: url,
                targetSize: CGSize(width: 414, height: 409),
                contentMode: .aspectFill)
    
            Nuke.loadImage(with: request, into: gameDetailPoster)
            
            gameDownloader.fetchGameById(gameId: result.id)
            self.gameDetailTitle.text = result.title
            self.gameDetailRating.text = String(result.rating)
            self.gameDetailReleaseDate.text = "Released Date : \(parseDate(dateUnformatted: result.releasedDate))"
        }
    }
    
    func parseDate(dateUnformatted: String)-> String{
           
           let fullDateArr : [String] = dateUnformatted.components(separatedBy: "-")
           let year = fullDateArr[0]
           let month = getMonthName(month: fullDateArr[1])
           let day = fullDateArr[2]
           let formattedDate : String = "\(day) \(month) \(year)"
           return formattedDate
       }
       
       func getMonthName(month: String)-> String{
           switch month {
           case "01":
               return "January"
           case "02":
               return "February"
           case "03":
               return "March"
           case "04":
               return "April"
           case "05":
               return "Mei"
           case "06":
               return "June"
           case "07":
               return "July"
           case "08":
               return "August"
           case "09":
               return "September"
           case "10":
               return "Oktober"
           case "11":
               return "November"
           case "12":
               return "Desember"
           default:
               return " "
           }
       }
}

protocol GameDownloaderDelegate{
    
    func didGameDownloaded(_ gameManager : GameDownloaderManager, game : GameDataById)
    func didFail(error: Error)
}

struct GameDownloaderManager{
    let gameURL = "https://api.rawg.io/api/games"
    
    var delegate: GameDownloaderDelegate?
    
    func fetchGameById(gameId : Int){
        let urlString = "\(gameURL)/\(gameId)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(error: error!)
                    return
                }
                if let safeData = data {
                    if let games = self.parseJSON(safeData) {
                        self.delegate?.didGameDownloaded(self, game: games)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ gameData: Data) -> GameDataById? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GameDataById.self, from: gameData)
            let id = decodedData.id
            let description = decodedData.description
            let game = GameDataById(id: id, description:description)
            return game
            
        } catch {
            delegate?.didFail(error: error)
            return nil
        }
    }
}

extension DetailGameViewController : GameDownloaderDelegate{
    func didGameDownloaded(_ gameManager: GameDownloaderManager, game: GameDataById) {
        DispatchQueue.main.async() {
            let editedText = game.description.replacingOccurrences(of: "<p>", with: "\n")
            let editedText2 = editedText.replacingOccurrences(of: "</p>", with: "\n")
            let editedText3 = editedText2.replacingOccurrences(of: "<br />", with: "\n")
            self.gameDescription.text = editedText3
        }
    }
    
    func didFail(error: Error) {
        print(error)
    }
    
 
    
//    func didUpdateGame(_ gameManager: GameManager, game: GamesModel) {
////        for item in game.results{
////            gamesData.append(item)
////            print("item appended : \(item.gameTitle)")
////        }
////         DispatchQueue.main.async() {
////            self.gameTableView.reloadData()
////        }
//    }
}


