//
//  AddChannelViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/5/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {
    //Outlets
    
    @IBOutlet weak var channelNameTxt: UITextField!
    @IBOutlet weak var channelDescTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

        // Do any additional setup after loading the view.
    }
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        view.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recoginzer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        guard let name = channelNameTxt.text, channelNameTxt.text != "" else {return}
        guard let description = channelDescTxt.text, channelDescTxt.text != "" else {return}
        
        if name != "" && description != ""{
            //MessageService.instance.addChannel(name: name, description: description) { (success) in
            SocketService.instance.addChannel(name: name, description: description) { (success) in
            if success{
                print("update channel list notif")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.present(CommonFunctions.instance.makeAlert(title: "Add Channel Failed", message: "Please try again later", action: "OK"), animated: true, completion: nil)
                }
            }
        }
    }
    

  

}
