//
//  ChatViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //Outlets
    
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var chatTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendBtn.isHidden = true
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.messagesLoaded(_:)), name: NOTIF_MESSAGES_LOADED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail() { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
            SocketService.instance.getMessage { (success) in
                if success {
                    self.tableView.reloadData()
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
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
        if !AuthService.instance.isLoggedIn {return}
        updateWithChannel()
        getMessagesForChannel()
    }
    
    @objc func messagesLoaded(_ NOTIF: Notification)
    {
        if !AuthService.instance.isLoggedIn {return}
        getMessagesForChannel()
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
            self.present(CommonFunctions.instance.makeAlert(title: "Not logged in", message: "Please log in to send a message", action: "OK"), animated: true, completion: nil)
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
    
    
    func getMessagesForChannel(){
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if (success)
            {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCellTableViewCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        else {return UITableViewCell()}
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return MessageService.instance.messages.count
    }
    @IBAction func chatTxtEditing(_ sender: Any) {
        if chatTxt.text == "" {sendBtn.isHidden = true}
        else {sendBtn.isHidden = false}
    }
    
}
