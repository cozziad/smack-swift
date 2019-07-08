//
//  LoginViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //Outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = userNameTxt.text, userNameTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        spinner.isHidden = false
        spinner.startAnimating()
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success{
                AuthService.instance.findUserByEmail() { (success) in
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.present(CommonFunctions.instance.makeAlert(title: "Login Error", message: "Please try again", action: "OK"), animated: true, completion: nil)
                        UserDataService.instance.logoutUser()
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                    }
                }
            }
            else{
            self.present(CommonFunctions.instance.makeAlert(title: "Invalid Login", message: "Please confirm your login credentials", action: "OK"), animated: true, completion: nil)
            }
        }
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
}
