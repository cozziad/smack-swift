//
//  createAccountViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class createAccountViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: FROM_CREATE_ACCOUNT_UNWIND, sender: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        print("press detected")
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{ print("registered user")}
            else {print("failed register")}
        }
    }
    @IBAction func chooseAvitarPressed(_ sender: Any) {
    }
    @IBAction func generateBackgroundPressed(_ sender: Any) {
    }
    
}
