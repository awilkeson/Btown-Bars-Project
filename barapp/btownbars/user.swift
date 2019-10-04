//
//  user.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/20/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var userimg: UIImage
    var array_fullname: String
    var array_username: String
    
    var name: String!
    
    init(userimg: UIImage,array_fullname: String, array_username: String) {
        self.userimg = userimg
        self.array_fullname = array_fullname
        self.array_username = array_username
    }
    
}
