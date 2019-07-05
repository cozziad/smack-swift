//
//  ChatViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail() { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    


}
