//
//  RegisterUserViewController.swift
//  proficiency05
//
//  Created by Ashley Wilkeson on 11/16/18.
//  Copyright © 2018 Ashley Wilkeson. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreGraphics

class RegisterUserViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var contactname1: UITextField!
    @IBOutlet weak var contactphone1: UITextField!

    @IBOutlet weak var contactname2: UITextField!
    @IBOutlet weak var contactphone2: UITextField!

    @IBOutlet weak var birthdate: UIDatePicker!


    @IBOutlet weak var userImagePicker: UIImageView!


    @IBOutlet weak var brothersSwitch: UISwitch!
    @IBOutlet weak var kokSwitch: UISwitch!
    @IBOutlet weak var upstairsSwitch: UISwitch!
    @IBOutlet weak var nicksSwitch: UISwitch!
    @IBOutlet weak var sportsSwitch: UISwitch!
    @IBOutlet weak var bluebirdSwitch: UISwitch!
    @IBOutlet weak var tapSwitch: UISwitch!


    @IBOutlet weak var brothersLabel: UILabel!
    @IBOutlet weak var kokLabel: UILabel!
    @IBOutlet weak var upstairsLabel: UILabel!
    @IBOutlet weak var nicksLabel: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    @IBOutlet weak var bluebirdLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!

    var favorites = Array<String>()
    var faves = Array<String>()
    
    var sysuser: Bool!
    var systemuser: Bool!
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
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
    
    
    @IBAction func importImage(_ sender: Any) {
        
        let image = UIImagePickerController()
        
        image.delegate=self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        
//        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
//            print(filePath)
//            myImageView.contentMode = .scaleAspectFit
//            myImageView.image = image
//        }
        
    }

    var imgstring:String!
    var imgtype:String!
    var newimage: UIImage!

//    func convertImageToBase64(image: UIImage) -> String {
//        let imageData = image.pngData()!
//        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
//    }

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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/defaultimage.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(usernameTextField.text ?? "")" // which is your parameters
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            myImageView.image = image
            
            newimage = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))

            let imageStr = convertImageTobase64(format: .png, image: newimage)
            print(imageStr!)
            
            let image_Str = imageStr!.replacingOccurrences(of: "+", with: "%2B")
            
            let url = URL(string: "http://cgi.sice.indiana.edu/~team68/imageupload.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "image=\(image_Str)&username=\(usernameTextField.text ?? "")" // which is your parameters
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favorites = self.faves
        self.systemuser = self.sysuser
        
        brothersSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")

        kokSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        upstairsSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        nicksSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        sportsSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        bluebirdSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        tapSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")


        changebroText()
        brothersSwitch.addTarget(self, action: #selector(BroSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changekokText()
        kokSwitch.addTarget(self, action: #selector(KOKSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changesportsText()
        sportsSwitch.addTarget(self, action: #selector(SportsSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changenicksText()
        nicksSwitch.addTarget(self, action: #selector(NicksSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changebluebirdText()
        bluebirdSwitch.addTarget(self, action: #selector(BluebirdSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changetapText()
        tapSwitch.addTarget(self, action: #selector(TapSwitchToggled(_:)), for: UIControl.Event.valueChanged)

        changeupstairsText()
        upstairsSwitch.addTarget(self, action: #selector(UpstairsSwitchToggled(_:)), for: UIControl.Event.valueChanged)
    }

    @IBAction func BroSwitchToggled(_ sender: UISwitch) {
        changebroText()
    }

    func changebroText() {
        if brothersSwitch.isOn {
            brothersLabel.text = "Added!" }
        else {
            brothersLabel.text = "" }
    }

    @IBAction func KOKSwitchToggled(_ sender: UISwitch) {
        changekokText()
    }

    func changekokText() {
        if kokSwitch.isOn {
            kokLabel.text = "Added!" }
        else {
            kokLabel.text = "" }
    }


    @IBAction func SportsSwitchToggled(_ sender: UISwitch) {
        changesportsText()
    }

    func changesportsText() {
        if sportsSwitch.isOn {
            sportsLabel.text = "Added!" }
        else {
            sportsLabel.text = "" }
    }


    @IBAction func UpstairsSwitchToggled(_ sender: UISwitch) {
        changeupstairsText()
    }

    func changeupstairsText() {
        if upstairsSwitch.isOn {
            upstairsLabel.text = "Added!" }
        else {
            upstairsLabel.text = "" }
    }

    @IBAction func NicksSwitchToggled(_ sender: UISwitch) {
        changenicksText()
    }

    func changenicksText() {
        if nicksSwitch.isOn {
            nicksLabel.text = "Added!" }
        else {
            nicksLabel.text = "" }
    }

    @IBAction func BluebirdSwitchToggled(_ sender: UISwitch) {
        changebluebirdText()
    }

    func changebluebirdText() {
        if bluebirdSwitch.isOn {
            bluebirdLabel.text = "Added!" }
        else {
            bluebirdLabel.text = "" }
    }

    @IBAction func TapSwitchToggled(_ sender: UISwitch) {
        changetapText()
    }

    func changetapText() {
        if tapSwitch.isOn {
            tapLabel.text = "Added!" }
        else {
            tapLabel.text = "" }
    }

    @IBAction func SaveBrosPressed(_ sender: UISwitch) {
            UserDefaults.standard.set(sender.isOn, forKey: "switchState")
            changebroText()
            }

    @IBAction func SaveKOKPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changekokText()
    }
    @IBAction func SaveUpstairsPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changeupstairsText()
    }
    @IBAction func SaveNicksPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changenicksText()
    }
    @IBAction func SaveSportsPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changesportsText()
    }
    @IBAction func SaveBluebirdPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changebluebirdText()
    }
    @IBAction func SaveTapPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        changetapText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //FUNCTIONS
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!


    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func userinsystem(username:String)-> Bool{
        var systemuser: Bool!
        
        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/systemusers.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=\(username)" // which is your parameters
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
                        if jsonresponse == "Username Already in System" {
                            systemuser = true
                        }
                        else {
                            systemuser = false
                        }
                    }
                } //if
            } catch {
                print(error)
            }
//            print(systemuser!)
            self.sysuser = systemuser!
//            print(self.sysuser!)
        } //task
       task.resume()
        sleep(1)
//        print(self.sysuser!)
        return self.sysuser!
    }

    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert",message: userMessage, preferredStyle: .alert)

            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!) in
                //code in this block will trigger when OK button tapped.
                print("OK button tapped")
                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

//    @IBAction func selectedImgPicker (_ sender: AnyObject) {
////        present(imagePicker, animated: true, completion: nil)
//    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel button tapped")

        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func registerButtonTapped(_ sender: Any) {
        print("Register button tapped")

        var tempfavorites = Array<String>()
        var favorite: String!
        
    //        validate required fields are not empty
        if (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (usernameTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (repeatPasswordTextField.text?.isEmpty)!
        {
            //display alert message and return
            displayMessage(userMessage: "All fields are quired to fill in.")
            return
        }
        
        if (userinsystem(username: usernameTextField.text!)) != false{
            displayMessage(userMessage: "Username already in use, Please pick another.")
            return
        }

        //validate password
        if
        ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
        {
            //display alert message and return
             displayMessage(userMessage: "Please make sure passwords match.")
            return
        }
        
        if userImagePicker.image == nil {
            let defaulturl = URL(string: "http://cgi.sice.indiana.edu/~team68/defaultimage.php")!
            var defaultrequest = URLRequest(url: defaulturl)
            defaultrequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            defaultrequest.httpMethod = "POST"
            let defaultpostString = "username=\(usernameTextField.text ?? "")" // which is your parameters
            defaultrequest.httpBody = defaultpostString.data(using: .utf8)
            
            let defaulttask = URLSession.shared.dataTask(with: defaultrequest) { data, response, error in
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
            defaulttask.resume()
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

//        uploadImg()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let birthday = dateFormatter.string(from: birthdate.date)

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/register.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "firstName=\(firstNameTextField.text ?? "")&lastName=\(lastNameTextField.text ?? "")&username=\(usernameTextField.text ?? "")&password=\(passwordTextField.text ?? "")&phone=\(phone.text ?? "")&email=\(email.text ?? "")&birthdate=\(birthday))&contactname1=\(contactname1.text ?? "")&contactphone1=\(contactphone1.text ?? "")&contactname2=\(contactname2.text ?? "")&contactphone2=\(contactphone2.text ?? "")" // which is your parameters
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
                    print ("OOps not good JSON formatted response")
                }
            }
            task.resume()
        }
    
        if brothersLabel.text == "Added!" {
            let newfavorite = "2"
            tempfavorites.append(newfavorite) }
        if kokLabel.text == "Added!" {
            let newfavorite = "7"
            tempfavorites.append(newfavorite) }
        if upstairsLabel.text == "Added!" {
            let newfavorite = "1"
            tempfavorites.append(newfavorite) }
        if nicksLabel.text == "Added!" {
            let newfavorite = "3"
            tempfavorites.append(newfavorite) }
        if sportsLabel.text == "Added!" {
            let newfavorite = "6"
            tempfavorites.append(newfavorite) }
        if bluebirdLabel.text == "Added!" {
            let newfavorite = "5"
            tempfavorites.append(newfavorite) }
        if tapLabel.text == "Added!" {
            let newfavorite = "4"
            tempfavorites.append(newfavorite) }
        
        self.faves = tempfavorites
        
//        print(tempfavorites)
//        print(self.faves)
        
        for fave in self.faves {
            favorite = fave
//            print(favorite!)
            
            let favurl = URL(string: "http://cgi.sice.indiana.edu/~team68/favorites.php")!
            var favrequest = URLRequest(url: favurl)
            favrequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            favrequest.httpMethod = "POST"
            let favpostString = "favorites=\(favorite ?? "")&username=\(usernameTextField.text ?? "")" // which is your parameters
            favrequest.httpBody = favpostString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: favrequest) { data, response, error in
                guard let data = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
    //                                    print("showing data")
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    //                    if let jsonArray = jsonData as? [[String: Any]]{
                    if let dictionary = jsonData as? [String: Any]{
                        if let jsonresponse = dictionary["favorites"] as? String {
                            print("faves \(jsonresponse)")
                        }
                        if let jsonresponse = dictionary["response"] as? String {
                            print("resposne \(jsonresponse)")
                        }
                        if let jsonresponse = dictionary["sql"] as? String {
                            print("sql \(jsonresponse)")
                        } //if
                    } //if
                } catch {
                    print(error)
                }
            } //data
            task.resume()
        }

        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
        self.displayMessage(userMessage: "Successfully registered a new account. Please proceed to Sign In.")
        sleep(2)
        self.dismiss(animated: true, completion: nil)
        
    } //registerButtonTapped
    

} //class
