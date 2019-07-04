//
//  AvatarCell.swift
//  smack
//
//  Created by Anthony Cozzi on 7/4/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView ()
    }
    
    func setupView () {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
}
