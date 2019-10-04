//
//  editProfileViewController.swift
//  capstone_btownbars
//
//  Created by Ashley Wilkeson on 2/20/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit

class editProfileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ep_name: UITextField!
    @IBOutlet weak var ep_username: UITextField!
    @IBOutlet weak var ep_phone: UITextField!
    @IBOutlet weak var ep_email: UITextField!
    
    @IBOutlet weak var ep_contact1name: UITextField!
    @IBOutlet weak var ep_contact1phone: UITextField!
    @IBOutlet weak var ep_contact2name: UITextField!
    @IBOutlet weak var ep_contact2phone: UITextField!
    
    @IBOutlet weak var editprofileimg: UIImageView!
    
    
    var p_name: String!
    var p_username = globalSignInViewController!.getuser()
    var p_phone: String!
    var p_email: String!
    
    var p_contact1name: String!
    var p_contact1phone: String!
    var p_contact2name: String!
    var p_contact2phone: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ep_name.text = p_name
        ep_name.textColor = UIColor.lightGray
        
        ep_username.text = p_username
        ep_username.textColor = UIColor.lightGray

        ep_phone.text = p_phone
        ep_phone.textColor = UIColor.lightGray
        
        ep_email.text = p_email
        ep_email.textColor = UIColor.lightGray
        
        ep_contact1name.text = p_contact1name
        ep_contact1name.textColor = UIColor.lightGray
        
        ep_contact1phone.text = p_contact1phone
        ep_contact1phone.textColor = UIColor.lightGray
        
        ep_contact2name.text = p_contact2name
        ep_contact2name.textColor = UIColor.lightGray
        
        ep_contact2phone.text = p_contact2phone
        ep_contact2phone.textColor = UIColor.lightGray
        
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
                            self.editprofileimg.image = UIImage(data: data! as Data)
                        }
                    }
                } //if
            } catch {
                print("error")
            }
        } //data
        imgtask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    
    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = image.pngData()
        case .jpeg(let compression): imageData = image.jpegData(compressionQuality:1)
        }
        return imageData?.base64EncodedString()
    }
    
    @IBOutlet weak var profileimg: UIImageView!
    var newimage: UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            profileimg.image = image
            
            newimage = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))
            let imageStr = convertImageTobase64(format: .png, image: newimage)
            print(imageStr!)
            
            let image_Str = imageStr!.replacingOccurrences(of: "+", with: "%2B")
            
            let url = URL(string: "http://cgi.sice.indiana.edu/~team68/updateimage.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "image=\(image_Str)&username=\(p_username)" // which is your parameters
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
                    //        print("showing data")
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["response"] as? String {
                            print(jsonresponse)
                        }
                    } //if
                } catch {
                    print(error)
                }
            } //data
            task.resume()
        }
        else {
            print("error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func editimgButton(_ sender: Any) {
        let image = UIImagePickerController()
        
        image.delegate=self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        
    }
    
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert",message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!) in
                //code in this block will trigger when OK button tapped.
                print("OK button tapped")
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
//                     let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController")
//                    self.present(profileViewController!,animated: true, completion: nil)
//                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func profile() {
        DispatchQueue.main.async {
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
            self.present(profileViewController,animated: true, completion: nil)
        }
    } //profile function
    
    func dashboard() {
        DispatchQueue.main.async {
            let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboardViewController") as! dashboardViewController
            self.present(dashboardViewController,animated: true, completion: nil)
        }
    } //dash function
    
    
    
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        print ("Save my profile")
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/editprofile.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
//        firstName=\(ep_name.text ?? "")&lastName=\(ep_name.text ?? "")&
        let postString = "username=\(ep_username.text ?? "")&phone=\(ep_phone.text ?? "")&email=\(ep_email.text ?? "")&contactname1=\(ep_contact1name.text ?? "")&contactphone1=\(ep_contact1phone.text ?? "")&contactname2=\(ep_contact2name.text ?? "")&contactphone2=\(ep_contact2phone.text ?? "")&p_username=\(p_username)" // which is your parameters
        request.httpBody = postString.data(using: .utf8)
        
        // Getting response for POST Method
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data{ do {
                    //                    print("showing data")
                    _ = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(data)
                    //                    print(json)
                }catch {print(error)
                    }}
                if error == nil {
                    return // check for fundamental networking error
                }
                
                // Getting values from JSON Response
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    _ = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                    
                }catch _ {
                    print ("Not good JSON formatted response")
                }
            }
            task.resume()
        }
        
        //display success message and return
        displayMessage(userMessage: "Profile Changes Saved!")
        
    } //save profile button tapped
    
}
