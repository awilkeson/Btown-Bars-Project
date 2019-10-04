////
////  messageDetail.swift
////  capstone_btownbars
////
////  Created by Ashley Wilkeson on 2/24/19.
////  Copyright © 2019 Ashley Wilkeson. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseDatabase
//import SwiftKeychainWrapper
//
//class messageDetail {
//    
//    private var _recipient: String!
//    private var _messageKey: String!
//    private var _messageRef: DatabaseReference!
//    
//    var currentUser = KeychainWrapper.standard.string(forKey: "userID")
//    var recipient: String {
//        return _recipient
//    }
//    
//    var messageKey: String {
//        return _messageKey
//    }
//    
//    var messageRef: DatabaseReference {
//        return _messageRef
//    }
//    
//    init(recipient: String) {
//        _recipient = recipient
//    }
//    
//    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
//        _messageKey = messageKey
//        
//        if let recipient = messageData["recipient"] as? String {
//            _recipient = recipient
//        }
//        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
//    }
//    
//}
