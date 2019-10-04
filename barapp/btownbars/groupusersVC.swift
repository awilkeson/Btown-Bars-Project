//
//  groupusersVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/20/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class groupusersVC: UIViewController{
    
    var users: [User] = []
    var some: [User] = []
    
    var images: [userImage] = []
    var someimages: [userImage] = []
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var useremail: String!
    var userfname: String!
    var uuseremail: String!
    var uuserfname: String!

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArray()
        createimgArray()
        
        DispatchQueue.main.async {
            self.users = self.some
            self.useremail = self.uuseremail
            self.userfname = self.uuserfname
            self.images = self.someimages

        }
    
        tableView.delegate = self
        tableView.dataSource = self
        
    } //viewdid load
    
    var pimage: UIImage!
    var uimage: UIImage!
    var imgstr: String!
    var img: String!
    
    var imagestr: String!
    var imgusername: String!
    
    
    func getusername(userimg: userImage)-> String {
        let username = userimg.array_username
        return username
    }
    func getimgstr(userimg: userImage)-> String {
        let imgstr = userimg.userimg
        return imgstr
    }
    func getimage(fullstring: String) -> UIImage {
        let url = NSURL(string: fullstring)
        let data = NSData(contentsOf: url! as URL)
        let image = UIImage(data: data! as Data)!
        return image
    }
    
    func createimgArray() {
        var tempimages: [userImage] = []
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/imageselectall.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "" // which is your parameter
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try? JSONSerialization.jsonObject(with:data, options: [])
                for item in (jsonData as! [Dictionary<String, AnyObject>]) {
                    //                    print(item)
                    for userdata in item {
                        
                        let username = "username"
                        let path = "photopath"
                        
                        if username == userdata.key {
                            self.imgusername = userdata.value as? String
                        }
                        if path == userdata.key {
                            self.imagestr = userdata.value as? String
                        }
                        
                    } //for loop
                    
                    let iusername = (self.imgusername!)
                    let imgstring = (self.imagestr!)
                    let newimguser = userImage(array_username: iusername, userimg: imgstring)
                    tempimages.append(newimguser)
                    
                } // for loop
                //                print(tempimages)
                
            } catch {
                print(error)
            } //catch
            self.someimages = tempimages
        } //task
        task.resume()
        //        DispatchQueue.main.async {
        //            sleep(1)
        //        }
    } //function
    
    
    
    @IBAction func groupnotify(_ sender: Any) {
        self.appDelegate?.scheduleNotification()
    }

    
    
    func getname(user: User)-> String {
        let name = user.array_fullname
        return name
    }
    
    func dashboard() {
        DispatchQueue.main.async {
            let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
            self.present(dashboardViewController,animated: true, completion: nil)
        }
    } //dash function

    var ufname:String!
    var ulname:String!
    var uusername:String!
    
    func createArray() {
        var tempusers: [User] = []

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/users.php")
        var request = URLRequest(url: url!)
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
                    for item in jsonArray as [Dictionary<String, AnyObject>] {

                        for userdata in item {

                            let fname = "i_fname"
                            let lname = "i_lname"
                            let username = "username"

                            if fname == userdata.key{
                                self.ufname = userdata.value as? String
                            }
                            if lname == userdata.key {
                                self.ulname = userdata.value as? String
                            }
                            if username == userdata.key {
                                self.uusername = userdata.value as? String
                            }
                        } //for loop

                        let fullname = (self.ufname + " " + self.ulname)
                        let username = (self.uusername!)
                        
                        if !(self.images.isEmpty) {
                            for image in self.images {
                                if (self.getusername(userimg: image) == username) {
                                    let uusername = self.getusername(userimg: image)
                                    let ustring = self.getimgstr(userimg: image)

                                    let fullstring = "http://cgi.sice.indiana.edu/~team68/"+ustring

                                    let url = NSURL(string: fullstring)
                                    let data = NSData(contentsOf: url! as URL)
                                    self.pimage = UIImage(data: data! as Data)
                                } else {
                                    self.pimage = UIImage(named: "profile0")!
                                }
                                self.uimage = self.pimage
                            }
                        }else {
                            self.pimage = UIImage(named: "profile0")!
                            self.uimage = self.pimage
                        }
                        
                        let newuser = User(userimg: self.uimage, array_fullname: fullname, array_username: username)
                        tempusers.append(newuser)
                    } // for loop
                    
                } catch {
                    print("error")
                } //catch
            
            self.some = tempusers
            
        } //task
        task.resume()
        
        DispatchQueue.main.async {
            sleep(1)
        }
        tableView.reloadData()

    } //function
    
    var finalimage: String!
    var fullstr: String!

} //class



extension groupusersVC: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
   
    func sendEmail(userUsername:String, groupName: String) {
        
        var user_email: String!
        var user_fname: String!
        
        print(userUsername)
        print(groupName)
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/getemail.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "username=\(userUsername)&group=\(groupName)" // which is your parameters
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.main.async {

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
                    print("showing data")
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
//                    if let jsonArray = jsonData as? [[String: Any]]{
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["sql"] as? String {
                            print(jsonresponse)
                        }
                        if let jsonresponse = dictionary["email"] as? String {
                            print(jsonresponse)
                        }
                    }
//                    for item in jsonData as! [Dictionary<String, AnyObject>] {
//                            print(item)
//                            for userdata in item {
//                                let email = "email"
//                                let name = "i_fname"
//
//                                if email == userdata.key{
//                                    self.uuserfname = userdata.value as? String
//                                    print(self.uuseremail)
//                                }
//                                if name == userdata.key{
//                                    self.uuseremail = userdata.value as? String
//                                    print(self.uuserfname)
//                                }
//                            }
//                            print(self.uuseremail!)
//                            print(self.uuserfname!)
//                        } //for
                    
                    
//                    } //jsonArray
                } catch {
                    print(error)
                }
            } //task
            task.resume()
            
        } //dispatch
//        DispatchQueue.main.async {
//
//            print("OUTSIDE \(self.userfname ?? "")")
//            print("OUTSIDE \(self.useremail ?? "")")
//
//            if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//                mail.mailComposeDelegate = self
//                mail.setToRecipients([self.useremail])
//                mail.setMessageBody("<p>Dear, \(self.userfname ?? "")You have been added to team \(groupName).self.self. If you wish to leave the group please do so in the Groups section of the app. Thank you! </p>", isHTML: true)
//
//                UIApplication.shared.keyWindow?.rootViewController?.present(mail, animated: true)
//                self.navigationController?.present(mail, animated: true, completion: nil)
//
//            } else {
//                print("error") }
//        } //dispatchs
        
    } //send email func

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let img = self.images[indexPath.row]
        
        func imguser () -> String{
            for image in self.images {
                if (users[indexPath.row].array_username == image.array_username) {
                    self.finalimage = self.getimgstr(userimg: image)
                }
            } //for
            
            let fstring = "http://cgi.sice.indiana.edu/~team68/"+self.finalimage!
            self.fullstr = fstring
            
            return self.fullstr
        }
        
        let full_string = imguser()
        let userimage = self.getimage(fullstring: full_string)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! userCell
        cell.setUser(user: user)
        cell.userimg?.image = userimage

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        func getname(user: User)-> String {
            let name = user.array_fullname
            return name
        }
        func getusername(user: User)-> String {
            let username = user.array_username
            return username
        }
        
        let selectedUsername = (getusername(user: users[indexPath.row]))
        
        
//        let groupViewController: createGroupVC = createGroupVC(nibName: nil, bundle: nil)
//        let getgroupName = groupViewController.groupnameinput
        
        let getgroupName = globalcreateGroupVC!.getgroup()
        
        sendEmail(userUsername: selectedUsername, groupName: getgroupName)
        
        let trimmedgroupName = getgroupName.trimmingCharacters(in: .whitespaces)
        let trimmedUsername = selectedUsername.trimmingCharacters(in: .whitespaces)
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/adduser.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username= \(trimmedUsername.lowercased())&groupName= \(trimmedgroupName)" // which are your parameters
        request.httpBody = postString.data(using: .utf8)
        
        // Getting response for POST Method
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data{
                    do {
                        //                        print("showing data")
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = jsonData as? [String: Any]{
                            if let jsonresponse = dictionary["sql 1"] as? String {
                                print(jsonresponse)
                            }
                            if let jsonresponse = dictionary["sql 2"] as? String {
                                print(jsonresponse)
                            }
                            if let jsonresponse = dictionary["response"] as? String {
                                print(jsonresponse)
                                // access individual value in dictionary
                                if jsonresponse == "Added to the Group!"{
                                    print("Success")
                                    
//                                    self.appDelegate?.scheduleNotification()
                                    
//                                    self.sendEmail(userUsername: trimmedUsername, groupName: trimmedgroupName)
                                    
                                    
                                    
                                    
                                    DispatchQueue.main.async {
                                        let alertController = UIAlertController(title: (getname(user: self.users[indexPath.row])), message: "Added to the Group!", preferredStyle: .alert)
                                        let FinishAction = UIAlertAction(title:"Finish",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("Finish button tapped")
                                            DispatchQueue.main.async {
    //                                            self.dismiss(animated: true, completion: nil)
                                                self.dashboard()
                                            }
                                        }
                                        let OKAction = UIAlertAction(title:"Add Another User",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("OK button tapped")
                                        }
                                        alertController.addAction(OKAction)
                                        alertController.addAction(FinishAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    } //dispatch
                                } //jsonresponse
                                if jsonresponse == "User Already Added"{
                                    print("Success")
                                    DispatchQueue.main.async {
                                        let alertController = UIAlertController(title: (getname(user: self.users[indexPath.row])), message: "User Already Added", preferredStyle: .alert)
                                        let FinishAction = UIAlertAction(title:"Finish",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("Finish button tapped")
                                            DispatchQueue.main.async {
                                                //                                            self.dismiss(animated: true, completion: nil)
                                                self.dashboard()
                                            }
                                        }
                                        let OKAction = UIAlertAction(title:"Add Another User",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("OK button tapped")
                                        }
                                        alertController.addAction(OKAction)
                                        alertController.addAction(FinishAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    } //dispatch
                                } //jsonresponse
                                if jsonresponse == "User Could Not Be Added" {
                                    print("Fail")
                                    DispatchQueue.main.async {
                                        let alertController = UIAlertController(title: (getname(user: self.users[indexPath.row])), message: "User Could Not Be Added.", preferredStyle: .alert)
                                        let FinishAction = UIAlertAction(title:"Finish",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("Finish button tapped")
                                            DispatchQueue.main.async {
                                                //      self.dismiss(animated: true, completion: nil)
                                                self.dashboard()
                                            }
                                        }
                                        let OKAction = UIAlertAction(title:"Add Another User",style: .default){
                                            (action:UIAlertAction!) in
                                            //code in this block will trigger when OK button tapped.
                                            print("OK button tapped")
                                        }
                                        alertController.addAction(OKAction)
                                        alertController.addAction(FinishAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    } //dispatch
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
    
    

