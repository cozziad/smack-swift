//
//  CommonFunctions.swift
//  smack
//
//  Created by Anthony Cozzi on 7/7/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import Foundation
import UIKit

class CommonFunctions{
    
    static let instance = CommonFunctions()
    
    func makeAlert(title: String,message:String,action:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        return alert
    }

}
