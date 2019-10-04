//
//  groupCell.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/21/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class groupCell: UITableViewCell {
 
    @IBOutlet weak var groupname: UILabel!
    
    
func setGroup(group: Group) {
        //        userimg.image = user.image
        groupname.text = group.groupname
    }
    
    
}
