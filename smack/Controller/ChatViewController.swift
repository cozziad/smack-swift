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
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var chatTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
         NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail() { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification){
       if AuthService.instance.isLoggedIn{
            MessageService.instance.findAllChannel { (success) in
            if success{
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }
            }
        }
       }
       else {channelNameLbl.text = "Smack"}
    }
    
    @objc func channelSelected(_ NOTIF: Notification)
    {
        updateWithChannel()
    }
    
    @objc func handleTap()
    {
        view.endEditing(true)
    }

    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if !AuthService.instance.isLoggedIn {
            self.present(CommonFunctions.instance.makeAlert(title: "Not logged in", message: "Please log in", action: "OK"), animated: true, completion: nil)
            return
        }
        
        guard let messageBody = chatTxt.text else {return}
        if messageBody != ""{
            SocketService.instance.sendMessage(messageBody: messageBody) { (success) in
                if (success)
                {
                    self.chatTxt.text = ""
                    self.chatTxt.resignFirstResponder()
                }
                else
                {
                    self.present(CommonFunctions.instance.makeAlert(title: "Message not sent", message: "Please try again", action: "OK"), animated: true, completion: nil)
                }
            }
        }
        else
        {
            self.present(CommonFunctions.instance.makeAlert(title: "Blank Message", message: "Please enter a message to send", action: "OK"), animated: true, completion: nil)
        }
    }
    
    
    func getMessagesForChannel (){
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if (success)
            {
                print ("got messages")
            }
        }
    }

}
