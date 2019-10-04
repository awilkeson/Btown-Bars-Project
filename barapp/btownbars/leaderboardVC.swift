//
//  leaderboardVC.swift
//  capstone_btownbars
//
//  Created by Andrew Frisinger on 3/31/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class leaderboardVC: UIViewController {

    var UserName: [Leaderboard] = []
    var place: [Leaderboard] = []
    
    var images: [userImage] = []
    var someimages: [userImage] = []
    
    @IBOutlet weak var  tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArray()
        createimgArray()
        
        DispatchQueue.main.async {
            self.UserName = self.place
            self.images = self.someimages
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    func getpoints(leaderboard: Leaderboard)-> String {
//        let points = leaderboard.array_totalPoints
//        return points!
//    }

    
    var ranking:String!
    var upts:String!
    var position:String!
    
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
    
    
    func createArray() {
        var board: [Leaderboard] = []
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/leaderboard.php")
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
                for item in (jsonData as! [Dictionary<String, AnyObject>]) {
                    for userdata in item {
                        let uname = "username"
                        let upoints = "points"
                        
                        if uname == userdata.key{
                            self.ranking = userdata.value as? String
                        }
                        if upoints == userdata.key{
                            self.upts = userdata.value as? String
                        }
                    } //for loop
                    
                    let Username = (self.ranking!)
                    let totalPoints = (self.upts!)
                    
                    if !(self.images.isEmpty) {
                        for image in self.images {
                            if (self.getusername(userimg: image) == Username) {
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
                    
                    let positionRank = Leaderboard(leaderboardimage: self.uimage, array_Username: Username, array_totalPoints: totalPoints)
                    board.append(positionRank)
                } // for loop
                
            } catch {
                print(error)
            } //catch
            
            self.place = board
            
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


extension leaderboardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaderboard = UserName[indexPath.row]
//        let img = self.images[indexPath.row]
        
        func imguser () -> String{
            for image in self.images {
                if (UserName[indexPath.row].array_Username == image.array_username) {
                    self.finalimage = self.getimgstr(userimg: image)
                }
            } //for

            let fstring = "http://cgi.sice.indiana.edu/~team68/"+self.finalimage!
            self.fullstr = fstring

            return self.fullstr
        }
        
        let full_string = imguser()
        let userimage = self.getimage(fullstring: full_string)
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell") as! leaderboardCell
        cell.setLeaderboard(leaderboard: leaderboard)
        cell.leaderboardimage?.image = userimage

        return cell
    }

}


