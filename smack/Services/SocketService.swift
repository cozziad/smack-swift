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
    
}
