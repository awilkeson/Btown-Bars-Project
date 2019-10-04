//
//  groupUser.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/23/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//
import Foundation
import UIKit

class groupUser {
    
    var userimg: UIImage
    var array_fullname: String
    var array_username: String
    var array_barlocation: String

    
    //    userimg: UIImage,
    init(array_fullname: String, array_username: String, array_barlocation: String, userimg: UIImage) {
        self.userimg = userimg
        self.array_fullname = array_fullname
        self.array_username = array_username
        self.array_barlocation = array_barlocation
    }
    
}
