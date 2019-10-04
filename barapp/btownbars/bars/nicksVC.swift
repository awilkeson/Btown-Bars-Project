//
//  nicksVC.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 3/18/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class nicksVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var montemp: [Special] = []
    var tuestemp: [Special] = []
    var wedtemp: [Special] = []
    var thurtemp: [Special] = []
    var fritemp: [Special] = []
    var sattemp: [Special] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grabspecials()
        
        //        self.tableView.register(brothersCell.self, forCellReuseIdentifier: "brothersCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    } //view did load
    
    var barid: String!
    var special: String!
    var day:String!
    
    func grabspecials() {
        var tempmon: [Special] = []
        var temptues: [Special] = []
        var tempwed: [Special] = []
        var tempthur: [Special] = []
        var tempfri: [Special] = []
        var tempsat: [Special] = []
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/nicksspecials.php")
        var request = URLRequest(url: url!)
        //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
                    for userdata in item {
                        let barID = "barID"
                        let special = "specials"
                        let day = "day"
                        
                        if barID == userdata.key{
                            self.barid = userdata.value as? String
                        }
                        if special == userdata.key {
                            self.special = userdata.value as? String
                        }
                        if day == userdata.key {
                            self.day = userdata.value as? String
                        }
                        
                    } //for loop
                    
                    if self.day == "Monday" {
                        let newspecial = Special(special: self.special)
                        tempmon.append(newspecial)
                    }
                    if self.day == "Tuesday" {
                        let newspecial = Special(special: self.special)
                        temptues.append(newspecial)
                    }
                    if self.day == "Wednesday" {
                        let newspecial = Special(special: self.special)
                        tempwed.append(newspecial)
                    }
                    if self.day == "Thursday" {
                        let newspecial = Special(special: self.special)
                        tempthur.append(newspecial)
                    }
                    if self.day == "Friday" {
                        let newspecial = Special(special: self.special)
                        tempfri.append(newspecial)
                    }
                    if self.day == "Saturday" {
                        let newspecial = Special(special: self.special)
                        tempsat.append(newspecial)
                    }
                    
                } // for loop
                
                
            } catch {
                print(error)
            }
            
            self.montemp = tempmon
            self.tuestemp = temptues
            self.wedtemp = tempwed
            self.thurtemp = tempthur
            self.fritemp = tempfri
            self.sattemp = tempsat
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } //task
        task.resume()
        
        
    } //function end
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        if section == 0 {
            label.text = "Monday" }
        if section == 1 {
            label.text = "Tuesday" }
        if section == 2 {
            label.text = "Wednesday"}
        if section == 3 {
            label.text = "Thursday" }
        if section == 4 {
            label.text = "Friday" }
        if section == 5 {
            label.text = "Saturday" }
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        
        return label
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return montemp.count }
        if section == 1 {
            return tuestemp.count }
        if section == 2 {
            return wedtemp.count }
        if section == 3 {
            return thurtemp.count }
        if section == 4 {
            return fritemp.count }
        if section == 5 {
            return sattemp.count }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let newspecial = montemp[indexPath.row]
        
        let newspecial = indexPath.section == 0 ? montemp[indexPath.row] :
            indexPath.section == 1 ? tuestemp[indexPath.row] :
            indexPath.section == 2 ? wedtemp[indexPath.row] :
            indexPath.section == 3 ? thurtemp[indexPath.row] :
            indexPath.section == 4 ? fritemp[indexPath.row] :
            indexPath.section == 5 ? sattemp[indexPath.row] :
            montemp[indexPath.row]
        
        let cell: nicksCell = self.tableView.dequeueReusableCell(withIdentifier: "nicksCell") as! nicksCell
        cell.setSpecial(special: newspecial)
        return cell
    }

    
}
