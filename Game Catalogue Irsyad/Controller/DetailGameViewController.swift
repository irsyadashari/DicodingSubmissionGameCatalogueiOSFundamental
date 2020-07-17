//
//  DetailGameViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

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

            let urlString = result.poster
            let url = URL(string: urlString)!
            
            self.gameDetailPoster.downloaded(from: url)
            self.gameDetailTitle.text = result.title
            self.gameDetailRating.text = String(result.rating)
            self.gameDetailReleaseDate.text = result.releasedDate
           }

    }
} 
