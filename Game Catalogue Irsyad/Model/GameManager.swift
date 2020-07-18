//
//  GameManager.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 14/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import Foundation

protocol GameManagerDelegate{
    
    func didUpdateGame(_ gameManager : GameManager, game : GamesModel)
    func didFailWithError(error: Error)
}

struct GameManager{
    let gameURL = "https://api.rawg.io/api/games"
    
    var delegate: GameManagerDelegate?
    
    func fetchGames() {
        let urlString = "\(gameURL)"
        performRequest(with: urlString)
    }
    
//    func fetchGameById(gameId : Int){
//        let urlString = "\(gameURL)/\(gameId)"
//        performRequest(with: urlString)
//    }
//    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let games = self.parseJSON(safeData) {
                        self.delegate?.didUpdateGame(self, game: games)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ gameData: Data) -> GamesModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GamesModel.self, from: gameData)
            let count = decodedData.count
            let results = decodedData.results
            let games = GamesModel(count: count, results: results)
            return games
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
