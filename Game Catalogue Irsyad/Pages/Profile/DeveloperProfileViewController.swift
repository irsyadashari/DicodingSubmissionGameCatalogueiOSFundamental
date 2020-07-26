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
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileJobLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNameLabel.text = defaults.string(forKey: "Fullname") ?? "Muhammad Irsyad Ashari"
        
        profileJobLabel.text = String(defaults.string(forKey: "Job") ?? "iOS Developer")
        
        profileEmailLabel.text = String(defaults.string(forKey: "Email") ?? "muhirsyadashari@gmail.com")
        
    self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        profilePic.layer.cornerRadius =  profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true;
        profilePic.layer.borderWidth = 4.0
        profilePic.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    
    @IBAction func goToEdit(_ sender: Any) {
        
//        defaults.set("Muhammad Irsyad Ashari", forKey: "Fullname")
//        defaults.set("iOS Developer", forKey: "Job")
//        defaults.set("muhirsyadashari@gmail.com", forKey: "Email")
        
        let editProfile = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        
        editProfile.profile = Profile(fullname : "String",job : "String", email: "")
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    @IBAction func backToHome(_ sender: Any) {navigationController?.popToRootViewController(animated: true)}
}
