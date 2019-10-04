//
//  profileViewController.swift
//  proficiency-05
//
//  Created by Ashley Wilkeson on 2/6/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import UIKit
import Foundation

class profileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
 
    @IBOutlet weak var emccontact1name: UILabel!
    @IBOutlet weak var emccontact1phone: UILabel!
    
    @IBOutlet weak var emccontact2name: UILabel!
    
    @IBOutlet weak var emccontact2phone: UILabel!
    
    @IBOutlet weak var profileimg: UIImageView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editprofile() {
        DispatchQueue.main.async {
            let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"editProfileViewController") as! editProfileViewController
            
            editProfileViewController.p_name = self.name.text!
            editProfileViewController.p_username = self.username.text!
            editProfileViewController.p_phone = self.phone.text!
            editProfileViewController.p_email = self.email.text!
            
            editProfileViewController.p_contact1name = self.emccontact1name.text!
            editProfileViewController.p_contact1phone = self.emccontact1phone.text!
            editProfileViewController.p_contact2name = self.emccontact2name.text!
            editProfileViewController.p_contact2phone = self.emccontact2phone.text!
            
            self.present(editProfileViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        editprofile()
    }//edit profile button tapped
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileimg.layer.borderWidth = 1
        profileimg.layer.masksToBounds = false
        profileimg.layer.borderColor = UIColor.black.cgColor
        profileimg.layer.cornerRadius = profileimg.frame.height/2
        profileimg.clipsToBounds = true
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/profile.php")
        var request = URLRequest(url: url!)
    //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
                        var i_username: String
                        var i_fname: String
                        var i_lname: String
                        var email: String
                        var phone: String

                        var contact_name1: String
                        var contact_phone1: String
                        var contact_name2: String
                        var contact_phone2: String

                        init(_ dictionary: [String: Any]) {
                            self.i_username = dictionary["username"] as? String ?? ""
                            self.i_fname = dictionary["i_fname"] as? String ?? ""
                            self.i_lname = dictionary["i_lname"] as? String ?? ""
                            self.email = dictionary["email"] as? String ?? ""
                            self.phone = dictionary["phone"] as? String ?? ""

                            self.contact_name1 = dictionary["contact_name1"] as? String ?? ""
                            self.contact_phone1 = dictionary["contact_phone1"] as? String ?? ""
                            self.contact_name2 = dictionary["contact_name2"] as? String ?? ""
                            self.contact_phone2 = dictionary["contact_phone2"] as? String ?? ""
                        }
                    }

                    var model = [User]() //Initialising Model Array
                    for dic in jsonArray{
                    model.append(User(dic)) // adding now value in Model array
                    }
                let userusername = (model[0].i_username)
                let fullname = (model[0].i_fname) + " " + (model[0].i_lname)
                let useremail = (model[0].email)
                let userphone = (model[0].phone)

                let contact_name1 = (model[0].contact_name1)
                let contact_phone1 = (model[0].contact_phone1)
                let contact_name2 = (model[0].contact_name2)
                let contact_phone2 = (model[0].contact_phone2)


                DispatchQueue.main.async {
                    self.name.text = fullname
                    self.username.text = userusername
                    self.email.text = useremail
                    self.phone.text = userphone
                    self.emccontact1name.text = contact_name1
                    self.emccontact1phone.text = contact_phone1
                    self.emccontact2name.text = contact_name2
                    self.emccontact2phone.text = contact_phone2
                }
            } catch {
                print("error")
            }//
        } //task
        task.resume()
        
        
        let imgurl = URL(string: "http://cgi.sice.indiana.edu/~team68/profileimg.php")
        var imgrequest = URLRequest(url: imgurl!)
        //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        imgrequest.httpMethod = "POST"
        let imgpostString = "username=\( globalSignInViewController!.getuser())" // which is your parameter
        imgrequest.httpBody = imgpostString.data(using: .utf8)
        
        let imgtask = URLSession.shared.dataTask(with: imgrequest) { data, response, error in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                        print("showing data")
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonData as? [String: Any]{
                    if let jsonresponse = dictionary["imagepath"] as? String {
                        print(jsonresponse)
                        DispatchQueue.main.async {
                            let url = NSURL(string: jsonresponse)
                            let data = NSData(contentsOf: url! as URL)
                            self.profileimg.image = UIImage(data: data! as Data)
                        }
                    }
                } //if
            } catch {
                print("error")
            }
        } //data
        imgtask.resume()

    } //view did load
    
    
} //end page
