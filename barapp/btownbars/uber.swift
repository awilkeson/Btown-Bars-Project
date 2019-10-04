//
//  uber.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 4/9/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class Uber: UIViewController {
    

    @IBAction func uberButtonLeave(_ sender: Any) {
    
        if let appURL = URL(string:"uber://"){
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
            let appName = "Uber"
            let appScheme = "\(appName)://"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL){
                UIApplication.shared.open(appSchemeURL!,options: [:], completionHandler: nil)
            }
            else {
                let alert = UIAlertController(title: "\(appName) Error..", message:" The app named \(appName) was not found, please install via App Store.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
    }
    
    
}
