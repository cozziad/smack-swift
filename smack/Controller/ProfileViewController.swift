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
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
    
    var editMode = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpView()}
    
    func setUpView(){
        if !AuthService.instance.isLoggedIn {return}
        
        username.isEnabled = false
        useremail.isEnabled = false
        
        username.text = UserDataService.instance.name
        useremail.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        view.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recoginzer: UITapGestureRecognizer){dismiss(animated: true, completion: nil)}
    
    @IBAction func closeModelPressed(_ sender: Any){dismiss(animated: true, completion: nil)}
    
    @IBAction func logoutPressed(_ sender: Any){
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: Any) {
        if !editMode{
            view.removeGestureRecognizer(closeTouch)
            editBtn.setTitle("Save", for: .normal)
            username.isEnabled = true
            useremail.isEnabled = true
            editMode = true
        }
        else{
            guard let name = username.text, username.text != "" else {return}
            guard let email = useremail.text, useremail.text != "" else {return}
            AuthService.instance.updateUser(name: name, email: email) { (success) in
                if success{
                     self.present(CommonFunctions.instance.makeAlert(title: "Account Updated", message: "Your acount information was updated", action: "OK"), animated: true, completion: nil)
                NotificationCenter.default.post(name: NOTIF_USER_UPDATED_PROFILE, object: nil)
                }
                else{
                    self.present(CommonFunctions.instance.makeAlert(title: "Account Update Failed", message: "Your account information was not updated", action: "OK"), animated: true, completion: nil)
                }
            }
            view.addGestureRecognizer(closeTouch)
            editBtn.setTitle("Edit", for: .normal)
            username.isEnabled = false
            useremail.isEnabled = false
            editMode = false
        }
        
        
    }
    
}
