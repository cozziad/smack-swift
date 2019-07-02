//
//  ChannelViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width-60
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
    performSegue (withIdentifier: TO_LOGIN, sender: nil)
    }
    
   

}
