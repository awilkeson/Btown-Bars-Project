//
//  sportsCell.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 4/7/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class sportsCell: UITableViewCell {
    
    
    @IBOutlet weak var barSpecial: UILabel!
    func setSpecial(special: Special) {
        barSpecial.text = special.special
    }
    
}
