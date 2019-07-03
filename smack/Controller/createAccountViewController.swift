//
//  createAccountViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class createAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: FROM_CREATE_ACCOUNT_UNWIND, sender: nil)
    }
    

}
