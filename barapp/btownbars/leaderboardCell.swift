//
//  leaderboardCell.swift
//  capstone_btownbars
//
//  Created by Andrew Frisinger on 4/1/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import UIKit

class leaderboardCell: UITableViewCell {

    @IBOutlet weak var leaderboardimage: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    
    func setLeaderboard(leaderboard: Leaderboard) {
        
        leaderboardimage?.layer.borderWidth = 1
        leaderboardimage?.layer.masksToBounds = false
        leaderboardimage?.layer.borderColor = UIColor.black.cgColor
        leaderboardimage?.layer.cornerRadius = (leaderboardimage?.frame.height)!/2
        leaderboardimage?.clipsToBounds = true
        
        
        leaderboardimage?.image = leaderboard.leaderboardimage
        Username.text = leaderboard.array_Username
        totalPoints.text = leaderboard.array_totalPoints
    }

}
