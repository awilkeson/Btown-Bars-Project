//
//  groupUsersCell.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/23/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class groupUserCell: UITableViewCell {
    
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var barlocation: UILabel!
    
    @IBOutlet weak var userimg: UIImageView?
    
    func setgroupUser(groupuser: groupUser) {
        
        userimg?.layer.borderWidth = 1
        userimg?.layer.masksToBounds = false
        userimg?.layer.borderColor = UIColor.black.cgColor
        userimg?.layer.cornerRadius = (userimg?.frame.height)!/2
        userimg?.clipsToBounds = true
        
        userimg?.image = groupuser.userimg
        fullname.text = groupuser.array_fullname
        username.text = groupuser.array_username
        barlocation.text = groupuser.array_barlocation
    }

}
