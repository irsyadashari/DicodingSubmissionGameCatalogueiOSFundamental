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
    
    // Temporary Game Data
    var game : GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // implementing game's data into UI
        if let result = game {
            let url = URL(string : result.poster)!
            let request = ImageRequest(
                url: url,
                targetSize: CGSize(width: 414, height: 409),
                contentMode: .aspectFill)
    
            Nuke.loadImage(with: request, into: gameDetailPoster)
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


