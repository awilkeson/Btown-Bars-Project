//
//  Leaderboard.swift
//  capstone_btownbars
//
//  Created by Andrew Frisinger on 4/1/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class Leaderboard {
    
    var leaderboardimage: UIImage
    var array_Username: String!
    var array_totalPoints: String!
    
    var points: String!
    
    init(leaderboardimage: UIImage,array_Username: String, array_totalPoints: String) {
        self.leaderboardimage = leaderboardimage
        self.array_Username = array_Username
        self.array_totalPoints = array_totalPoints
    }

}

