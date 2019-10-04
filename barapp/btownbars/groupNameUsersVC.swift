//
//  groupNameUsersVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/22/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation

class groupNameUsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var groupsusers: [groupUser] = []
    var some: [groupUser] = []
    
    var images: [userImage] = []
    var someimages: [userImage] = []
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupname: UILabel!
    
    
    var ufname:String!
    var ulname:String!
    var uusername:String!
    var groupName: String!

    var barlocation: String!
    
    var barlocal: String!
    
    var imagestr: String!
    var imgusername: String!
    
    var pimage: UIImage!
    var uimage: UIImage!
    var imgstr: String!
    var img: String!
    
    
    var finalimage: String!
    var fullstr: String!
    
    var locValue:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use in foreground
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 100
            
            let kok:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166309, -86.528036), radius: 50, identifier: "Kilroys on Kirkwood")
             let upstairs:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166317, -86.528360), radius: 50, identifier: "The Upstairs Pub")
             let nicks:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.166654, -86.528626), radius: 50, identifier: "Nicks English Hut")
             let bluebird:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.167814, -86.533465), radius: 50, identifier: "The Bluebird")
             let brothers:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.168183, -86.533797), radius: 50, identifier: "Brothers Bar & Grill")
             let sports:CLCircularRegion = CLCircularRegion (center: CLLocationCoordinate2DMake(39.169172, -86.533946), radius: 50, identifier: "Kilroys Sports")
            
            locationManager.startMonitoring(for: kok)
            locationManager.startMonitoring(for: upstairs)
            locationManager.startMonitoring(for: nicks)
            locationManager.startMonitoring(for: bluebird)
            locationManager.startMonitoring(for: brothers)
            locationManager.startMonitoring(for: sports)
        }
        
        groupname.text = groupName
        
        createimgArray()
        
        createArray()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.barlocal = "Not in a Bar"
        
        sleep(1)
        self.images = self.someimages
        self.groupsusers = self.some
    }
    
    @IBAction func addUserButton(_ sender: Any) {
        
        DispatchQueue.main.async {

            let createGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "createGroupVC") as! createGroupVC
            print(self.groupName!)
            createGroupVC.group = self.groupName!
            self.present(createGroupVC,animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered \(region.identifier)")
        self.barlocal = region.identifier
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/updatebar.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "bar=\(self.barlocal ?? "")" // which is your parameter
        request.httpBody = postString.data(using: .utf8)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Left \(region.identifier)")
        self.barlocal = "Not in a bar"
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/updatebar.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "bar=\(self.barlocal ?? "")" // which is your parameter
        request.httpBody = postString.data(using: .utf8)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        for currentlocation in locations {
            print("\(String(describing: index)):\(currentlocation)")
            print(self.barlocal!)
        }
    }
    
    func dashboard() {
        DispatchQueue.main.async {
            let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
            self.present(dashboardViewController,animated: true, completion: nil)
        }
    } //dash function

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
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/imageselect.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "groupName=\(groupName ?? "")" // which is your parameter
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
    
 
    func createArray() {
        var tempgroupusers: [groupUser] = []
//        var barlocal: String!
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/getgroupusers.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "groupName=\(groupName ?? "")" // which is your parameter
        request.httpBody = postString.data(using: .utf8)
        
//        DispatchQueue.main.async {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try JSONSerialization.jsonObject(with:data, options: [])
                
                for item in jsonData as! [Dictionary<String, AnyObject>] {
                    for userdata in item {
                        
                        let fname = "i_fname"
                        let lname = "i_lname"
                        let username = "username"
                        let userbar = "bar"
                        
                        if fname == userdata.key{
                            self.ufname = userdata.value as? String
                        }
                        if lname == userdata.key {
                            self.ulname = userdata.value as? String
                        }
                        if username == userdata.key {
                            self.uusername = userdata.value as? String
                        }
                        if userbar == userdata.key {
                            self.barlocation = userdata.value as? String
                        }
                        
                    } //for loop
                    
                    let fullname = (self.ufname + " " + self.ulname)
                    let username = (self.uusername!)
                    let barLocal = (self.barlocation!)
                    

                    
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
                    
                    print(self.images)
                    print(self.uimage)
//                    self.uimage = UIImage(named: "profile-1")
                    
                    let newgroupuser = groupUser(array_fullname: fullname, array_username: username, array_barlocation: barLocal, userimg: self.uimage)
                    
                    tempgroupusers.append(newgroupuser)
                    
                } // for loop
                
            } catch {
                print(error)
            } //catch
            self.some = tempgroupusers
            
        } //task
        task.resume()
//        }
        self.tableView.reloadData()

    } //function
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsusers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.groupsusers[indexPath.row]
        let img = self.images[indexPath.row]
        
        func imguser () -> String{
            for image in self.images {
                if (self.groupsusers[indexPath.row].array_username == image.array_username) {
                    self.finalimage = self.getimgstr(userimg: image)
                }
            } //for
            
            let fstring = "http://cgi.sice.indiana.edu/~team68/"+self.finalimage!
            self.fullstr = fstring
            
            return self.fullstr
        }
        
        let full_string = imguser()
        let userimage = self.getimage(fullstring: full_string)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupUserCell") as! groupUserCell
        cell.setgroupUser(groupuser: user)
        cell.userimg?.image = userimage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
} //class
