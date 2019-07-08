//
//  SocketService.swift
//  smack
//
//  Created by Anthony Cozzi on 7/5/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
   
    override init() {
        super.init()
    }
    
    func establishConnection(){
        let socket = manager.defaultSocket
        socket.connect()
        print("open socket")
    }
    
    func closeConnection(){
        let socket = manager.defaultSocket
        socket.disconnect()
        print("close socket")
    }
    
    func addChannel(name:String, description:String, completion: @escaping CompletionHandler){
        let socket = manager.defaultSocket
        socket.emit("newChannel", name,description)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler)
    {
        let socket = manager.defaultSocket
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            let channel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelID)
            MessageService.instance.channels.append(channel)
            completion(true)
        }
    }
    
    func getMessage(completion: @escaping CompletionHandler)
    {
        if !AuthService.instance.isLoggedIn {return}
        
        let socket = manager.defaultSocket
        socket.on("messageCreated") { (dataArray, ack) in
        guard let messageBody = dataArray[0] as? String else {return}
        guard let channelId = dataArray[2] as? String else {return}
        guard let userName = dataArray[3] as? String else {return}
        guard let userAvatar = dataArray[4] as? String else {return}
        guard let userAvatarColor = dataArray[5] as? String else {return}
        guard let id = dataArray[6] as? String else {return}
        guard let timeStamp = dataArray[7] as? String else {return}
        
            
        if channelId == MessageService.instance.selectedChannel?.id{
            let message = Message(message: messageBody, userName:userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                 MessageService.instance.messages.append(message)
        }
        completion(true)
        }
    }
    
    func sendMessage(messageBody:String,completion: @escaping CompletionHandler)
    {
        let socket = manager.defaultSocket
        let userID = UserDataService.instance.id 
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        guard let userName = UserDataService.instance.name as String? else {return}
        guard let userAvatar = UserDataService.instance.avatarName as String? else {return}
        guard let userAvatarColor = UserDataService.instance.avatarColor as String? else {return}
        
        socket.emit("newMessage", messageBody,userID,channelId,userName,userAvatar,userAvatarColor)
        completion(true)
    }
    
    func getTypingUsers (_ completionHandler: @escaping (_ typingUsers: [String:String]) -> Void)
    {
        let socket = manager.defaultSocket
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    func startTyping (channelId:String,completion: @escaping CompletionHandler)
    {
        let socket = manager.defaultSocket
        let userName = UserDataService.instance.name
        
        socket.emit("startType",userName,channelId)
    }
    
    func stopTyping (channelId:String,completion: @escaping CompletionHandler)
    {
        let socket = manager.defaultSocket
        let userName = UserDataService.instance.name
        
        socket.emit("stopType",userName,channelId)
    }
    
}
