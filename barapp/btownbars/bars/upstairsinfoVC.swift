//
//  upstairsinfoVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 2/28/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit


class upstairsinfoVC: UIViewController {
    
    
    @IBOutlet weak var barName: UILabel!
    @IBOutlet weak var barLocation: UILabel!
    @IBOutlet weak var barEmail: UILabel!
    @IBOutlet weak var barPhone: UILabel!
    @IBOutlet weak var barWeb: UILabel!
    @IBOutlet weak var barHours: UILabel!
    @IBOutlet weak var barDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/upstairs.php")
        var request = URLRequest(url: url!)
        //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"
        request.httpMethod = "POST"
        let postString = "username=\( globalSignInViewController!.getuser())" // which is your parameter
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:dataResponse, options: [])
                //                    print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                struct User {
                    var barName: String
                    var barLocation: String
                    var barDescription: String
                    var barHours: String
                    var barEmail: String
                    var barPhone: String
                    var barWeb: String
                    
                    init(_ dictionary: [String: Any]) {
                        self.barName = dictionary["bar_name"] as? String ?? ""
                        self.barDescription = dictionary["description"] as? String ?? ""
                        self.barHours = dictionary["hours"] as? String ?? ""
                        self.barLocation = dictionary["location"] as? String ?? ""
                        self.barEmail = dictionary["email"] as? String ?? ""
                        self.barPhone = dictionary["phone"] as? String ?? ""
                        self.barWeb = dictionary["website"] as? String ?? ""
                        
                    }
                }
                
                var model = [User]() //Initialising Model Array
                for dic in jsonArray{
                    model.append(User(dic)) // adding now value in Model array
                }
                let barName = (model[0].barName)
                let barDescription = (model[0].barDescription)
                let barLocation = (model[0].barLocation)
                let barHours = (model[0].barHours)
                
                let barPhone = (model[0].barPhone)
                let barEmail = (model[0].barEmail)
                let barWeb = (model[0].barWeb)
                
                
                DispatchQueue.main.async {
                    self.barName.text = barName
                    self.barDescription.text = barDescription
                    self.barLocation.text = barLocation
                    self.barHours.text = barHours
                    self.barEmail.text = barEmail
                    self.barPhone.text = barPhone
                    self.barWeb.text = barWeb
                }
            } catch {
                print("error")
            }//
        } //task
        task.resume()
        
        
    }
    
}

