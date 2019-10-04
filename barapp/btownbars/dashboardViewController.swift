//
//  dashboardViewController.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 11/16/18.
//  Copyright © 2018 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class dashboardViewController: UIViewController,  CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var pintpoints: String!
    var points: String!
    
    var bar:String!
    var tempbar: String!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var pintpointsLbl: UILabel!
    
    @IBOutlet weak var kokbarname: UILabel!
    @IBOutlet weak var kokbarspecial: UILabel!
    
    @IBOutlet weak var upstairsbarname: UILabel!
    @IBOutlet weak var upstairsbarspecial: UILabel!
    
    @IBOutlet weak var brothersbarname: UILabel!
    @IBOutlet weak var brothersbarspecial: UILabel!
    
    @IBOutlet weak var nicksbarname: UILabel!
    @IBOutlet weak var nicksbarspecial: UILabel!
    
    @IBOutlet weak var tapbarname: UILabel!
    @IBOutlet weak var tapbarspecial: UILabel!
    
    @IBOutlet weak var bluebirdbarname: UILabel!
    @IBOutlet weak var bluebirdbarspecial: UILabel!
    
    @IBOutlet weak var sportsbarname: UILabel!
    @IBOutlet weak var sportsbarspecial: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        // 1
        _ = self.navigationController?.navigationBar
        
        // 2
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.yellow
//        nav?.prefersLargeTitles = true
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        // 4
        let image = UIImage(named: "bbars")
        imageView.image = image
        
        // 5
        navigationItem.titleView = imageView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bar = ""
        
        getpintpoints()
        setSpecials()
        
        dayspecials()
        
        usernameLbl.text = globalSignInViewController!.getuser()
        
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
//            self.locationManager.distanceFilter = 100
            
            let kok:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166309, -86.528036), radius: 10, identifier: "Kilroys on Kirkwood")
            let upstairs:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166317, -86.528360), radius: 10, identifier: "The Upstairs Pub")
            let nicks:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166654, -86.528626), radius: 10, identifier: "Nicks English Hut")
            let bluebird:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.167814, -86.533465), radius: 10, identifier: "The Bluebird")
            let brothers:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.168183, -86.533797), radius: 10, identifier: "Brothers Bar & Grill")
            let sports:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.169172, -86.533946), radius: 10, identifier: "Kilroys Sports")
            
            self.locationManager.startMonitoring(for: kok)
            self.locationManager.startMonitoring(for: upstairs)
            self.locationManager.startMonitoring(for: nicks)
            self.locationManager.startMonitoring(for: bluebird)
            self.locationManager.startMonitoring(for: brothers)
            self.locationManager.startMonitoring(for: sports)
            
//            DispatchQueue.main.async {
//                self.bar = self.tempbar
//            }
        }
    }
    
    func dashboard() {
        DispatchQueue.main.async {
            let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
            self.present(dashboardViewController,animated: false, completion: nil)
        }
    } //dash function
    
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Check In Status:",message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!) in
                //code in this block will trigger when OK button tapped.
                print("OK button tapped")
                DispatchQueue.main.async {
                    self.dashboard()
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
  
    func getpintpoints() {
        var _: String!
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/pintpoints.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(globalSignInViewController!.getuser())" // which is your parameters
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try JSONSerialization.jsonObject(with:data, options: [])
                for item in jsonData as! [Dictionary<String, AnyObject>] {
                    for userdata in item {
                        
                        let points = "points"
                        
                        if points == userdata.key{
                            self.points = userdata.value as? String
                        }
                    } //for
                } //for
                
            } catch {
                print("error")
            }//
            
            self.pintpoints = self.points
            DispatchQueue.main.async {
                self.pintpointsLbl.text = self.pintpoints
            }
        } //task
        task.resume()
    }
    
    
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("Sign out button tapped")
//        dismiss(animated: true, completion: nil)
        func loginview() {
            
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.present(loginViewController,animated: true, completion: nil)
            }
        }
        loginview()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered \(region.identifier)")
        self.bar = region.identifier
//        print(self.bar!)
        
    } //func
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){
        print("Left \(region.identifier)")
        self.bar = "Not in a bar"

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/leavebar.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(globalSignInViewController!.getuser())" // which is your parameters
        request.httpBody = postString.data(using: .utf8)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        for _ in locations {
//            print("\(index):\(currentlocation)")
        }
    }
    
    
    @IBAction func barcheckin(_ sender: Any) {
//        var userpoints: String!
//        print("BAR CHECK IN: \(self.bar!)")
    
        if (self.bar!.isEmpty) {
            self.displayMessage(userMessage: "You're not in a Bar.")
        }
        else if (self.bar! == "Not in a bar") {
//            print("NOT IN: \(self.bar!)")
            
            self.displayMessage(userMessage: "You're not in a Bar.")
        }
        
        else if (self.bar! != "Not in a bar") {
//            print("IN: \(self.bar!)")

            let url = URL(string: "http://cgi.sice.indiana.edu/~team68/addpoints.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "username=\(globalSignInViewController!.getuser())&bar=\(self.bar!)" // which is your parameters
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                //                if let data = data{
                guard let data = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["response"] as? String {
                            print(jsonresponse)
                            if jsonresponse == "Points Added"{
//                                print("Success")
                            } //jsonresponse
                            if jsonresponse == "Points Not Added"{
//                                print("Fail")
                            } //jsonresponse
                        } //if let statement
                    } //let dictionary
                } catch {
                    print(error)
                }
                
                self.displayMessage(userMessage: "You've been checked in!")
                
            } //task
            task.resume()
            
        } //if
        
        
    }
        
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
            func profileview() {
                
                DispatchQueue.main.async {
                    let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
                    self.present(profileViewController,animated: true, completion: nil)
                }
            }
            profileview()

    } //profileButtonTapped
    
    
    @IBOutlet weak var kokFave: UIImageView!
    @IBOutlet weak var upstairsFave: UIImageView!
    @IBOutlet weak var brothersFave: UIImageView!
    @IBOutlet weak var nicksFave: UIImageView!
    @IBOutlet weak var tapFave: UIImageView!
    @IBOutlet weak var bluebirdFave: UIImageView!
    @IBOutlet weak var sportsFave: UIImageView!
    
    
    func setSpecials() {
        var favebar:String!
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/getuserfaves.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(globalSignInViewController!.getuser())" // which is your parameters
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try JSONSerialization.jsonObject(with:data, options: [])
                for item in jsonData as! [Dictionary<String, AnyObject>] {
                    for userdata in item {
                        let barname = "bar_name"
                        if barname == userdata.key{
                            favebar = userdata.value as? String
                            
                            if favebar == "The Upstairs Pub" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.upstairsFave.image = image
                                }
                            }
                            if favebar == "Nick's English Hut" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.nicksFave.image  = image
                                }
                            }
                            if favebar == "Kilroy's on Kirkwood" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.kokFave.image  = image
                                }
                            }
                            if favebar == "Bear's Place" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.tapFave.image  = image
                                }
                            }
                            if favebar == "The Bluebird" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.bluebirdFave.image  = image
                                }
                            }
                            if favebar == "Kilroy's Sports Bar" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.sportsFave.image  = image
                                }
                            }
                            if favebar == "Brother's Bar & Grill" {
                                DispatchQueue.main.async {
                                    let image = UIImage(named: "star")
                                    self.brothersFave.image  = image
                                }
                            }
                        }
                    } //for loop

                    
                } // for loop
                
            } catch {
                print(error)
            } //catch
            
        } //task
        task.resume()

    } //getspecials func
    
    let barlist = Array(arrayLiteral: "1","2","3","4","5","6","7")
    
    var bname: String!
    var dayspecial: String!
    
    func dayspecials() {

        for bar in barlist {
            let barnames = bar
            
            let url = URL(string: "http://cgi.sice.indiana.edu/~team68/dashbarinfo.php")
            var request = URLRequest(url: url!)
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "bar=\(barnames)" // which is your parameters
            request.httpBody = postString.data(using: .utf8)
            
            
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard let dataResponse = data,
//                    error == nil else {
//                        print(error?.localizedDescription ?? "Response Error")
//                        return }
//                do{
//                    let jsonResponse = try JSONSerialization.jsonObject(with:dataResponse, options: [])
//                    //                    print(jsonResponse) //Response result
//
//                    guard let jsonArray = jsonResponse as? [[String: Any]] else {
//                        return
//                    }
//
//                    struct Bar {
//                        var barname: String
//                        var barspecial: String
//
//                        init(_ dictionary: [String: Any]) {
//                            self.barname = dictionary["bar_name"] as? String ?? ""
//                            self.barspecial = dictionary["specials"] as? String ?? ""
//                        }
//                    }
//
//                    var model = [Bar]() //Initialising Model Array
//                    for dic in jsonArray{
//                        model.append(Bar(dic)) // adding now value in Model array
//                    }
//
//                    let bname = (model[0].barname)
//                    let bspecial = (model[0].barspecial)
//
//                    DispatchQueue.main.async {
//
//                        if bname == "Kilroy's on Kirkwood" {
//                            self.barname.text = bname
//                            self.barspecial.text = bspecial }
//
//                    }
//                } catch {
//                    print("error")
//                }//
//            } //task
//            task.resume()
            
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    let jsonData = try? JSONSerialization.jsonObject(with:data, options: [])
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["bar"] as? String {
//                            print("BAR \(jsonresponse)")
                            self.bname = jsonresponse
                        }
                        if let jsonresponse = dictionary["special"] as? String {
//                            print("SPECIAL \(jsonresponse)")
                            self.dayspecial = jsonresponse
                        }
                        if let jsonresponse = dictionary["response"] as? String {
//                            print("RESPONSE \(jsonresponse)")
                            if jsonresponse == "No Bar Info" {
                                self.dayspecial = "No Specials Today"
                            }
                                if self.bname == "7" {
                                        DispatchQueue.main.async {
                                        self.kokbarname.text = "Kilroy's on Kirkwood"
                                        self.kokbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "1" {
                                        DispatchQueue.main.async {
                                        self.upstairsbarname.text = "The Upstairs Pub"
                                        self.upstairsbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "2" {
                                        DispatchQueue.main.async {
                                        self.brothersbarname.text = "Brother's Bar & Grill"
                                        self.brothersbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "3" {
                                        DispatchQueue.main.async {
                                        self.nicksbarname.text = "Nick's English Hut"
                                        self.nicksbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "4" {
                                        DispatchQueue.main.async {
                                        self.tapbarname.text = "Bear's Place"
                                        self.tapbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "5" {
                                        DispatchQueue.main.async {
                                        self.bluebirdbarname.text = "The Bluebird"
                                        self.bluebirdbarspecial.text = self.dayspecial
                                        }
                                    }
                                    if self.bname == "6" {
                                        DispatchQueue.main.async {
                                        self.sportsbarname.text = "Kilroy's Sports Bar"
                                        self.sportsbarspecial.text = self.dayspecial
                                        }
//                                    }
//                                } // for loop

                            } else {
                                print("No Bar Info Found")
                            }
                            print("")
                        } //if
                    }
                    else {
                        print(error)
                    }
                } catch {
                    print(error)
                } //catch
            } //task
            task.resume()
            
            
        } //for bar in barlist
    }
    
    
} //class
