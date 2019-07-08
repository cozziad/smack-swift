//
//  MessageCellTableViewCell.swift
//  smack
//
//  Created by Anthony Cozzi on 7/7/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {

    //outlets
    
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var msgDate: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    override func awakeFromNib() {super.awakeFromNib()}
    
    func configureCell(message:Message){
        messageBody.text = message.message
        userName.text = message.userName
        userImg.image = UIImage(named:message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
