//
//  AuthService.swift
//  smack
//
//  Created by Anthony Cozzi on 7/3/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool{
        get{
            return defaults.bool (forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue,forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String{
        get{
            if let aT = defaults.value (forKey: TOKEN_KEY) as? String{
                return aT
            } else {return ""}
        }
        set {
            defaults.set(newValue,forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String{
        get{
            if let uE = defaults.value (forKey: USER_EMAIL) as? String{
                return uE
            } else {return ""}
        }
        set {
            defaults.set(newValue,forKey: USER_EMAIL)
        }
    }
    
    func registerUser (email:String, password:String, completion: @escaping CompletionHandler){
        UserDataService.instance.logoutUser()
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email":lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func loginUser (email:String, password:String, completion: @escaping CompletionHandler){
        self.isLoggedIn = false
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email":lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    if self.userEmail != "" {
                        self.isLoggedIn = true
                        completion(true)
                    }
                    else{
                        UserDataService.instance.logoutUser()
                        completion(false)
                    }
                }
                catch{
                    UserDataService.instance.logoutUser()
                    completion(false)
                    return
                }
                
            } else {
                completion(false)
                UserDataService.instance.logoutUser()
            }
        }
    }
    
    func createUser (avatarColor: String, avatarName: String, email:String, name:String,completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email":lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                    
                    let id = json["_id"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData (id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
                }
                catch{
                    UserDataService.instance.logoutUser()
                    completion(false)
                    return
                }
                completion(true)
            }else {
                completion(false)
                UserDataService.instance.logoutUser()
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func findUserByEmail (completion: @escaping CompletionHandler){
        let lowerCaseEmail = self.userEmail.lowercased()
        let url: String = "\(URL_FIND_BY_EMAIL)\(lowerCaseEmail)"
        
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                    
                    let id = json["_id"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData (id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
                }
                catch{
                    UserDataService.instance.logoutUser()
                    completion(false)
                    return
                }
                completion(true)
            }
            else {
                UserDataService.instance.logoutUser()
                completion(false)
            }
        }
    }
    
}
