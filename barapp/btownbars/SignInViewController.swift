//
//  SignInViewController.swift
//  proficiency05
//
//  Created by Ashley Wilkeson on 11/16/18.
//  Copyright © 2018 Ashley Wilkeson. All rights reserved.
//


//var globalusername = "hjoy"

import UIKit
import Foundation
import StoreKit

var globalSignInViewController: SignInViewController?

class SignInViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
func getuser() -> String{
    let usernameinput:String = self.usernameTextField.text!
    return (usernameinput)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        globalSignInViewController = self 
        
//        func getuser() -> String{
//            var usernameinput:String = usernameTextField.text!
////            print(usernameinput)
//            return (usernameinput)
//        }
    
    }//view did load

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert",message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!) in
                //code in this block will trigger when OK button tapped.
                print("OK button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
            self.present(registerViewController,animated: true, completion: nil)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        //read values from text fields
        var username = usernameTextField.text
        let password = passwordTextField.text

        
        //check if required fields are not empty
        if (username?.isEmpty)! || (password?.isEmpty)!
        {
            //display alert message here
            print("Username \(String(describing: username)) or password \(String(describing: password)) is empty")
            displayMessage(userMessage: "One of the required fields is missing.")
            return
        }
        
        //create activity indicator
        let myActivityIndicator = UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)

        //position activity indicator in the center of the main view
        myActivityIndicator.center = view.center

        //if needed, you can prevent activity indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false

        //start activity indicator
        myActivityIndicator.startAnimating()

        view .addSubview(myActivityIndicator)
    
        
        func dashboardview() {
            DispatchQueue.main.async {
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [0]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        
        func loginview() {
            DispatchQueue.main.async {
                let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.present(SignInViewController,animated: true, completion: nil)
            }
        }

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/login.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(usernameTextField.text ?? "")&password=\(passwordTextField.text ?? "")" // which is your parameters
        request.httpBody = postString.data(using: .utf8)

        // Getting response for POST Method
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data{ do {
//                    print("showing data")
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["response"] as? String {
                            // access individual value in dictionary
                            if jsonresponse == "Correct Password"{
                                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                                dashboardview()
                            } //jsonresponse
                            if jsonresponse == "Incorrect Password" {
                                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                                self.displayMessage(userMessage: "Incorrect password, please try again.")
                            } //jsonresponse
                            if jsonresponse == "Incorrect User" {
                                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                                self.displayMessage(userMessage: "User not in system, please register.")
                                loginview()
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
    } //sign in button
} //view controller class
