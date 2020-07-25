//
//  DeveloperProfileViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 15/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class DeveloperProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        profilePic.layer.cornerRadius =  profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true;
        profilePic.layer.borderWidth = 4.0
        profilePic.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }

    @IBAction func backToHome(_ sender: Any) {navigationController?.popToRootViewController(animated: true)}
}
