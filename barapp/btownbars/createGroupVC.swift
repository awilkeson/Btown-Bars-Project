//
//  createGroupVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/21/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

var globalcreateGroupVC: createGroupVC?


class createGroupVC: UIViewController {
    
    var groupName: String!
    var group: String!
    
    @IBOutlet weak var groupnameinput: UITextField!
    
    func getgroup() -> String{
        let groupnameinput:String = self.groupnameinput.text!
        return (groupnameinput)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalcreateGroupVC = self
        
        groupnameinput.text = group

    }
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert",message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!) in
                //code in this block will trigger when OK button tapped.
                print("OK button tapped")
//                self.groupnameinput.text = ""
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
//                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func creategroupButtonPressed(_ sender: UIButton) {
        print("create group button pressed")
        let groupName = groupnameinput.text

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/creategroup.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "groupName=\(groupName ?? "")" // which is your parameters
        request.httpBody = postString.data(using: .utf8)

        // Getting response for POST Method
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data{
                    do {
//                        print("showing data")
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = jsonData as? [String: Any]{
                            if let jsonresponse = dictionary["response"] as? String {
//                                print(jsonresponse)
                                // access individual value in dictionary
                                if jsonresponse == "Group Created!"{
                                    print("Success")
                                    self.displayMessage(userMessage: "Group Created!")
                                } //jsonresponse
                                if jsonresponse == "Group Already Created"{
                                    print("Fail")
                                    self.displayMessage(userMessage: "Group Already Created")
                                } //jsonresponse
                                if jsonresponse == "Group Could Not Be Created" {
                                    print("Fail")
                                    self.displayMessage(userMessage: "Group couldn't be created.")

                                } //jsonresponse
                            } //if let statement
                        } //let dictionary
                    } //do statement
                } //data=data statement
                if error == nil {
                    return // check for fundamental networking error
                }

            } //task
            task.resume()
        } //dispatchqueue
        
    } //button
    
    //            let userSearch = self.storyboard?.instantiateViewController(withIdentifier:"groupusersVC") as! groupusersVC
    //            self.present(userSearch, animated: false, completion: nil)
    
}

