//
//  GameManager.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 13/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import Foundation

struct GameManager{
    let GamesURL = "https://api.rawg.io/api/games"
    
    func fetchGames(){
        let urlString = "\(GamesURL)"
        performRequest(urlString : urlString)
    }
    
    func performRequest(urlString : String){
        //1. Create URL
        if let url = URL(string: urlString){
            //2. Create a URL session
            let session = URLSession(configuration : .default)
            
            //3. Creating a task for the session
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //4. Start the task
            task.resume()
            
        }
    }
    
    func handle(data : Data?, response : URLResponse?, error : Error?){
        if error != nil{
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
        
    }
    
}
