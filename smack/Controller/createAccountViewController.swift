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
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: FROM_CREATE_ACCOUNT_UNWIND, sender: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{
                AuthService.instance.loginUser(email: email, password: pass) { (success) in
                    if success {
                        AuthService.instance.createUser(avatarColor: self.avatarColor, avatarName: self.avatarName, email: email, name: name) { (success) in
                            if success {
                                print("user created")
                                self.performSegue(withIdentifier: FROM_CREATE_ACCOUNT_UNWIND, sender: nil)
                            }
                            else {print("failed create")}
                        }
                    }
                    else {print("failed login")}
                }
            }
            else {print("failed register")}
        }
    }
    @IBAction func chooseavatarPressed(_ sender: Any) {
    }
    @IBAction func generateBackgroundPressed(_ sender: Any) {
    }
    
}
