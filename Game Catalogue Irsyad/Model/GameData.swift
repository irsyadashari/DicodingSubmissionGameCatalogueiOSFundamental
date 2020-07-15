//
//  Game.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 10/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit
import Foundation

struct GamesModel : Codable{
    let count : Int
//    let next : String
    let results : [GameData]
}

struct GameData : Codable{
    let gameId : Int
    let gamePoster : String
    let gameTitle : String
    let gameReleasedDate : String
    let gameRating : Float
    
    enum CodingKeys: String, CodingKey{
        
        case gameId = "id"
        case gamePoster = "background_image"
        case gameTitle = "name"
        case gameReleasedDate = "released"
        case gameRating = "rating"
    }
}



// CONTOH DALAM ARRAY
//-----------------------------------------------------------------
//func dcdJSON(data: Data) {
//    let decoder = JSONDecoder()
//
//    let games = try! decoder.decode(Games.self, from: data)
//
//    games.games.forEach{ game in
//        print("id : \(game.id)")
//        print("released date : \(game.released)")
//        print("name : \(game.name)")
//
//    }
//    print("PAGE: \(games.count)")
//    print("TOTAL RESULTS: \(games.next)")
//
//}
