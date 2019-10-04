//
//  specialCell.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/27/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class brothersCell: UITableViewCell {
    
    @IBOutlet weak var barSpecial: UILabel!
    
    
func setSpecial(special: Special) {
    barSpecial.text = special.special
    }

}
