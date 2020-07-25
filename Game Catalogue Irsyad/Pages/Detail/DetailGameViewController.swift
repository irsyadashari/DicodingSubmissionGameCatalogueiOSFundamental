//
//  DetailGameViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit
import Nuke
import RealmSwift

class DetailGameViewController: UIViewController {
    @IBOutlet weak var gameDetailPoster: UIImageView!
    @IBOutlet weak var gameDetailTitle: UILabel!
    @IBOutlet weak var gameDetailRating: UILabel!
    @IBOutlet weak var gameDetailReleaseDate: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var favoriteBtnDetail: UIButton!
    
    //Database Realm
     var favGames: Results<FavoriteGameData>?
    
    // Temporary Game Data
    var game : GameModel?
    var gameDownloader = GameDownloaderManager()
    let realm = try! Realm() //A Valid way according to documentation to declare Realm object althougt it use '!'
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        favGames = realm.objects(FavoriteGameData.self)  // Ini untuk Load Data ke variable global
        gameDownloader.delegate = self
        
        // implementing game's data into UI
        if let result = game {
            
            //checking if games is favorited
            if favGames != nil{
                for item in favGames!{
                    if item.id == result.id{
                        favoriteBtnDetail.isSelected = true
                        favoriteBtnDetail.imageView?.image = UIImage(named: "favorited-star")
                    }
                }
            }

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
    
    @IBAction func backToHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func favoriteBtn(_ sender: UIButton) {
        favoriteBtnController(sender: sender)
    }
    
    func favoriteBtnController(sender : UIButton){
        if(sender.isSelected == false){
            
            favoriteBtnDetail.imageView?.image = UIImage(named: "favorited-star")
            sender.isSelected = true
        
            let favoritedGame = FavoriteGameData()
            favoritedGame.id = game!.id
            favoritedGame.title = String(game!.title)
            favoritedGame.poster = String(game!.poster)
            favoritedGame.releasedDate = String(game!.releasedDate)
            favoritedGame.rating = String(game!.rating)
            saveFavoriteGames(favGame: favoritedGame)
            
            let alert = UIAlertController(title: "Notes", message: "Game has been added to favorite", preferredStyle: .alert)
            self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
            
        }else if(sender.isSelected == true){
            favoriteBtnDetail.imageView?.image = UIImage(named: "not-favorited")
            sender.isSelected = false
            
            deleteFavoriteGames()
            
            let alert = UIAlertController(title: "Notes", message: "Game has been removed from favorite", preferredStyle: .alert)
            self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }

    
    func saveFavoriteGames(favGame : FavoriteGameData){
        do {
            try realm.write{
                realm.add(favGame) //WITH REALM TO SAVE DATA
            }
        } catch  {
            print(error)
        }
    }
    
    func deleteFavoriteGames(){
           do {
               try realm.write{
                for item in realm.objects(FavoriteGameData.self){
                    if(item.id == game!.id){
                        realm.delete(item) // ini untuk delete, TETAP HARUS ADA DI DALAM realm.write
                    }
                }
               }
           } catch  {
               print(error)
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
}


