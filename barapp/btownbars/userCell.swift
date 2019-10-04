//
//  userCell.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/20/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import UIKit

class userCell: UITableViewCell {

    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var username: UILabel!
    
    func setUser(user: User) {
        
        userimg?.layer.borderWidth = 1
        userimg?.layer.masksToBounds = false
        userimg?.layer.borderColor = UIColor.black.cgColor
        userimg?.layer.cornerRadius = (userimg?.frame.height)!/2
        userimg?.clipsToBounds = true
        
        userimg.image = userimg.image
        userFullname.text = user.array_fullname
        username.text = user.array_username
    }
    
    
}
