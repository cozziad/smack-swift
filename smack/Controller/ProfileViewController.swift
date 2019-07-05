//
//  ProfileViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/4/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpView() {
        if AuthService.instance.isLoggedIn{
            username.text = UserDataService.instance.name
            useremail.text = UserDataService.instance.email
            profileImg.image = UIImage(named: UserDataService.instance.avatarName)
            profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        view.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recoginzer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
