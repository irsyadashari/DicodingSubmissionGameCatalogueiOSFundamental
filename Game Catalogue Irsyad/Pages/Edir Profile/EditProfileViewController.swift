//
//  EditProfileViewController.swift
//  Game Catalogue Irsyad
//
//  Created by Irsyad Ashari on 26/07/20.
//  Copyright © 2020 Ashari Corps. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editNameLabel: UITextField!
    @IBOutlet weak var editJobLabel: UITextField!
    @IBOutlet weak var editEmailLabel: UITextField!
    
    var profile : Profile?
    let defaults = UserDefaults.standard
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        let fullname = String(defaults.string(forKey: "Fullname") ?? "Muhammad Irsyad Ashari")
        editNameLabel.text = fullname
        
        let job = String(defaults.string(forKey: "Job") ?? "iOS Developer")
        editJobLabel.text = job
        
        let email = String(defaults.string(forKey: "Email") ?? "muhirsyadashari@gmail.com")
        editEmailLabel.text = email
    }

    @IBAction func backBtn(_ sender: Any) {
        let profile = DeveloperProfileViewController(nibName: "DeveloperProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        defaults.set("\(String(editNameLabel.text!))", forKey: "Fullname")
        defaults.set("\(String(editJobLabel.text!))", forKey: "Job")
        defaults.set("\(String(editEmailLabel.text!))", forKey: "Email")
        
        //Present Notif
        let alert = UIAlertController(title: "Notes", message: "Profile has been updated!", preferredStyle: .alert)
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
        
        let profile = DeveloperProfileViewController(nibName: "DeveloperProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    

}
