//
//  GameTableViewCell.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 10/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {


    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
