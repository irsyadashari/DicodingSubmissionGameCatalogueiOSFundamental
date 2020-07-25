//
//  GameModelRealm.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 23/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import RealmSwift
import Foundation

class Item : Object{
    
    @objc dynamic var poster : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var releasedDate : String = ""
    @objc dynamic var rating : String = ""
    
    var parentFavorite = LinkingObjects(fromType: FavoriteGameData.self, property: "items")
  
}
