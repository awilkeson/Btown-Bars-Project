////
////  MessagesCell.swift
////  capstone_btownbars
////
////  Created by Ashley Wilkeson on 2/25/19.
////  Copyright © 2019 Ashley Wilkeson. All rights reserved.
////
//
//import UIKit
//import SwiftKeychainWrapper
//
//class MessagesCell: UITableViewCell {
//    
//    @IBOutlet weak var recievedMessageLbl: UILabel!
//    @IBOutlet weak var recievedMessageView: UIView!
//    @IBOutlet weak var sentMessageLbl: UILabel!
//    @IBOutlet weak var sentMessageView: UIView!
//    
//    var message: Message!
//    var currentUser = KeychainWrapper.standard.string(forKey: "userID")
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func configCell(message: Message) {
//        self.message = message
//        
//        if message.sender == currentUser {
//            
//            sentMessageView.isHidden = false
//            
//            sentMessageLbl.text = message.message
//            
//            recievedMessageLbl.text = ""
//            
//            recievedMessageLbl.isHidden = true
//            
//        } else {
//            
//            sentMessageView.isHidden = true
//            
//            sentMessageLbl.text = ""
//            
//            recievedMessageLbl.text = message.message
//            
//            recievedMessageLbl.isHidden = false
//            
//        }
//    }
//    
//}
