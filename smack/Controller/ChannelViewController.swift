//
//  ChannelViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/2/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBAction func prepareForUnwind (segue:UIStoryboardSegue){}
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width-60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userUpdatedProfile(_:)), name: NOTIF_USER_UPDATED_PROFILE, object: nil)
        
        
        //May need to get rid of the logged in list here
        if AuthService.instance.isLoggedIn{
            SocketService.instance.getChannel{(success) in
                if success{self.tableView.reloadData()}
            }
        
            SocketService.instance.getMessage { (newMessage) in
                if newMessage.channelId != MessageService.instance.selectedChannel?.id{
                    MessageService.instance.unreadChannels.append(newMessage.channelId)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }
        else {performSegue (withIdentifier: TO_LOGIN, sender: nil)}
    }
    
    override func viewDidAppear(_ animated: Bool) {setUpUserInfo()}
    
    @objc func userDataDidChange(_ notif: Notification){setUpUserInfo()}
    
    @objc func channelsLoaded(_ notif: Notification){self.tableView.reloadData()}
    
    func setUpUserInfo(){
        if AuthService.instance.isLoggedIn{
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }
        else{
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? TableViewCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    @objc func userUpdatedProfile(_ NOTIF: Notification){
        if !AuthService.instance.isLoggedIn {return}
        loginBtn.setTitle(UserDataService.instance.name, for: .normal)
    }
    
    @IBAction func AddChannelPressed(_ sender: Any) {
         if AuthService.instance.isLoggedIn{
            let addChannel = AddChannelViewController()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
         else{
            self.present(CommonFunctions.instance.makeAlert(title: "Not logged in", message: "Please log in to add a channel", action: "OK"), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0{
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
}
