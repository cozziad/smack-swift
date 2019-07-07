//
//  UserDataService.swift
//  smack
//
//  Created by Anthony Cozzi on 7/4/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private (set) var id = ""
    public private (set) var avatarColor = ""
    public private (set) var avatarName = ""
    public private (set) var email = ""
    public private (set) var name = ""
    
    func setUserData(id:String, avatarColor: String, avatarName: String, email:String, name:String)
    {
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    func setavatarName (avatarName: String)
    {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String)-> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r,g,b : NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        
        
        let defaultColor = UIColor.lightGray
        guard let rUR = r else {return defaultColor}
        guard let gUR = g else {return defaultColor}
        guard let bUR = b else {return defaultColor}
        
        let rF = CGFloat(rUR.doubleValue)
        let gF = CGFloat(gUR.doubleValue)
        let bF = CGFloat(bUR.doubleValue)
        let aF : CGFloat = 1
        
        return UIColor(red: rF, green: gF, blue: bF, alpha: aF)
        
    }
    
    func logoutUser ()
    {
        id = ""
        avatarName = ""
        email = ""
        avatarColor = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
