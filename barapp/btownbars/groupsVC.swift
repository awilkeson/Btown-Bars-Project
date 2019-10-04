//
//  groupsVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/21/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class groupsVC: UIViewController {
    
    var groups: [Group] = []
    var some: [Group] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArray()
        
        DispatchQueue.main.async {
            self.groups = self.some
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func getname(group: Group)-> String {
        let name = group.groupname
        return name!
    }
    
    var response: String!
    var res: String!
    var userresponse: String!
    
    
    func displayMessage(userMessage:String,groupname:String)-> String {
        let trimmedgroupName = groupname.trimmingCharacters(in: .whitespaces)

        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Leave Group",message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title:"Yes",style: .default){
                (action:UIAlertAction!) in
                let url = URL(string: "http://cgi.sice.indiana.edu/~team68/removegroup.php")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let postString = "groupName= \(trimmedgroupName ?? "")&username=\(globalSignInViewController?.getuser() ?? "")" // which are your parameters
                request.httpBody = postString.data(using: .utf8)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data{
                        do {
                            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = jsonData as? [String: Any]{
                                if let jsonresponse = dictionary["response"] as? String {
                                    print(jsonresponse)
                                    self.response = jsonresponse
                                } //if
                                if let jsonresponse = dictionary["sql"] as? String {
                                    print(jsonresponse)
//                                    self.response = jsonresponse
                                } //if
                            } //if
                        } //do
                        catch {
                            print("error")
                        }
                    } //data
                    
                    self.res = self.response
                    
                } //task
                task.resume()
                
                print("OK button tapped")
            }
            let NOAction = UIAlertAction(title:"No",style: .default){
                (action:UIAlertAction!) in
                print("NO button tapped")

            }
            
            alertController.addAction(OKAction)
            alertController.addAction(NOAction)
            self.present(alertController, animated: true, completion: nil)
            
            self.userresponse = self.res
            print(self.res)
            
        }
        return "user"
    }
    
    
    func dashboard() {
        DispatchQueue.main.async {
            let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
            self.present(dashboardViewController,animated: true, completion: nil)
        }
    } //dash function
    
    var group:String!
    
    func createArray() {
        var tempgroups: [Group] = []
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/groups.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "username=\( globalSignInViewController!.getuser())" // which is your parameter
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try JSONSerialization.jsonObject(with:data, options: [])
                for item in jsonData as! [Dictionary<String, AnyObject>] {
//                    print(item)
                    for userdata in item {
                        let gname = "groupName"
                        if gname == userdata.key{
                            self.group = userdata.value as? String
                        }
                    } //for loop

                    let groupName = (self.group!)
                    let newgroup = Group(groupname: groupName)
                    tempgroups.append(newgroup)
                    
//                    print(groupName)
                    
                } // for loop
                
            } catch {
                print(error)
            } //catch
            
            self.some = tempgroups
            
            } //task
        task.resume()
        
        DispatchQueue.main.async {
            sleep(1)
        }
    } //function

    
    
} //class


extension groupsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! groupCell
        cell.setGroup(group: group)
        return cell
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let response = displayMessage(userMessage: "Are you sure you want to leave \(self.groups[indexPath.row].groupname ?? "")", groupname: self.groups[indexPath.row].groupname)
            
                self.groups.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        
        } //if
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let groupViewController: createGroupVC = createGroupVC(nibName: nil, bundle: nil)
        //        let getgroupName = groupViewController.groupnameinput
        
        //        let getgroupName = globalcreateGroupVC!.getgroup()
        
        let trimmedgroupName = getname(group: self.groups[indexPath.row]).trimmingCharacters(in: .whitespaces)
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/getgroup.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "groupName= \(trimmedgroupName)" // which are your parameters
        request.httpBody = postString.data(using: .utf8)
        
        // Getting response for POST Method
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data{
                    do {
                        //                        print("showing data")
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = jsonData as? [String: Any]{
                            if (dictionary["sql"] as? String) != nil {
                                //                                print(jsonresponse)
                            }
                            if let jsonresponse = dictionary["response"] as? String {
                                //                                print(jsonresponse)
                                // access individual value in dictionary
                                if jsonresponse == "Group Found!"{
                                    print("Success")
                                    
                                    DispatchQueue.main.async {
                                        let groupNameUsersVC = self.storyboard?.instantiateViewController(withIdentifier:"groupNameUsersVC") as! groupNameUsersVC
                                        
                                        groupNameUsersVC.groupName = trimmedgroupName
                                        
                                        self.present(groupNameUsersVC, animated: false, completion: nil)
                                        sleep(UInt32(0.5))
                                    }
                                    
                                    
                                } //jsonresponse
                                if jsonresponse == "Group Could Not Be Found." {
                                    print("Fail")
                                    
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
        
    }
    
}
