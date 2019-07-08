//
//  MessageService.swift
//  smack
//
//  Created by Anthony Cozzi on 7/5/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService{
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler)
    {
        if !AuthService.instance.isLoggedIn {return}
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                do{
                    if let json = try JSON(data: data).array {
                        self.clearChannels()
                        for item in json{
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                        }
                    }
                }
                catch{
                    completion(false)
                    return
                }
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    func addChannel(name:String, description:String,completion: @escaping CompletionHandler)
    {
        if !AuthService.instance.isLoggedIn {return}
        let body: [String: Any] = [
            "name": name,
            "description":description
        ]
        
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    func clearChannels ()
    {
        channels.removeAll()
    }
    
    func clearMessages ()
    {
        messages.removeAll()
    }
    
    func findAllMessagesForChannel (channelId: String, completion: @escaping CompletionHandler){
        if !AuthService.instance.isLoggedIn {return}
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                self.clearMessages()
                guard let data = response.data else {return}
                do{
                    if let json = try JSON(data: data).array {
                        for item in json{
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            self.messages.append(message)
                        }
                    }
                }
                catch{
                    completion(false)
                    return
                }
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}
