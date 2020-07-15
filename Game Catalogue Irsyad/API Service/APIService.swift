//
//  APIService.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 11/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.

import Foundation

class APIService{
    
    static let shared = APIService()
    
    let BASE_URL =  "https://api.rawg.io/api"
    let GAMES = "/games"
    
    func getGames(){
        
        guard let url = URL(string : BASE_URL + GAMES) else{return}
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let response = response{
                print(response)
            }
            if let data = data{
                do {
//                     let json = try JSONSerialization.jsonObject(with: data)
                    let json = try JSONDecoder().decode(GameData.self, from: data)
                    print(json)
                } catch {
                    print(error.localizedDescription)
                    return
                }
               
            }
        }
        task.resume()
    }
}


