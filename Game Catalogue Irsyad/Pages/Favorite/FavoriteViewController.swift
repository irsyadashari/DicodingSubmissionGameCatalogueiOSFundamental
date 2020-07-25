//
//  FavoriteViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 23/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit
import RealmSwift
import Nuke

class FavoriteViewController: UIViewController {

  var favGames: Results<FavoriteGameData>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var noFavText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)

        loadFavoriteGames()
        
        //Nuke Preparation
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
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(UINib(nibName: "GameTVCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
    
    @IBAction func goBackToHome(_ sender: Any) {navigationController?.popToRootViewController(animated: true)}
    
    func loadFavoriteGames(){
        
        favGames = realm.objects(FavoriteGameData.self)  // Ini untuk Load Data ke variable global
        
        favoriteTableView.reloadData()
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

extension FavoriteViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(favGames?.count == 0){
            noFavText.isHidden = false
            favoriteTableView.isHidden = true
        }else{
            noFavText.isHidden = true
            favoriteTableView.isHidden = false
        }
        return favGames?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "GameCell", for : indexPath) as! GameTVCell
        
        // This line doesn't change
        let url = URL(string : favGames?[indexPath.row].poster ?? "")
        let request = ImageRequest(
            url: url!,
            targetSize: CGSize(width: 280, height: 170),
            contentMode: .aspectFill)
        
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "loading-image-cardview-game-poster"),
            transition: .fadeIn(duration: 0.5)
        )
        
        Nuke.loadImage(with: request, options: options, into: cell.gamePoster)
        cell.gameTitle.text = favGames?[indexPath.row].title ?? "Belum Ada game favorit"
        cell.gameRating.text = favGames?[indexPath.row].rating ?? ""
        cell.gameReleasedDates.text = "Released Date : \(parseDate(dateUnformatted: favGames?[indexPath.row].releasedDate ?? ""))"

        return cell
    }
    
    
}

extension FavoriteViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        detail.game = GameModel(
            id: favGames?[indexPath.row].id ?? 0,
            poster: favGames?[indexPath.row].poster ?? "Not Found",
            title: favGames?[indexPath.row].title ?? "title not found",
            releasedDate: favGames?[indexPath.row].releasedDate ?? "released date not found",
            rating: String(favGames?[indexPath.row].rating ?? "ratings not found"))
        
        // Push mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}
