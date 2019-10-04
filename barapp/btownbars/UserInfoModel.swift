//
//  UserInfoModel.swift
//  proficiency05
//
//  Created by Ashley Wilkeson on 11/18/18.
//  Copyright © 2018 Ashley Wilkeson. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject {
    //properties
    
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @firstName, @lastName, @username, and @password parameters
    
    init(firstName: String, lastName: String, username: String, password: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "First Name: \(String(describing: firstName)), Last Name: \(String(describing: lastName)), Username: \(String(describing: username)), Password: \(String(describing: password))"
        
    }
    
}
