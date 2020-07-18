//
//  GameTVCell.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class GameTVCell: UITableViewCell {

    @IBOutlet weak var cell: UIView!
    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReleasedDates: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
