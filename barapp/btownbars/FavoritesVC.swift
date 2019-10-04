////
////  FavoritesVC.swift
////  capstone_btownbars
////
////  Created by Andrew Frisinger on 4/8/19.
////  Copyright © 2019 Ashley Wilkeson. All rights reserved.
////
////Switches work, Data is stored. Need to get sign up and cancel to work and have to link to database. Need to create php file and figure out how to have favorites shown on different page.
////Still get this error: Unknown class _TtC18capstone_btownbars22BluebirdFavoriteSwitch in Interface Builder file
//
//import UIKit
//
//class FavoritesVC: UIViewController {
//    
//    
//    @IBOutlet weak var BrothersFavoriteSwitch: UISwitch!
//    @IBOutlet weak var KOKFavoriteSwitch: UISwitch!
//    @IBOutlet weak var SportsFavoriteSwitch: UISwitch!
//    @IBOutlet weak var NicksFavoriteSwitch: UISwitch!
//    @IBOutlet weak var BluebirdFavoriteSwitch: UISwitch!
//    @IBOutlet weak var TapFavoriteSwitch: UISwitch!
//    @IBOutlet weak var UpstairsFavoriteSwitch: UISwitch!
//    
//    
//    @IBOutlet weak var brothersLabel: UILabel!
//    @IBOutlet weak var KOKLabel: UILabel!
//    @IBOutlet weak var sportsLabel: UILabel!
//    @IBOutlet weak var nicksLabel: UILabel!
//    @IBOutlet weak var bluebirdLabel: UILabel!
//    @IBOutlet weak var tapLabel: UILabel!
//    @IBOutlet weak var upstairsLabel: UILabel!
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        BrothersFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        KOKFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        SportsFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        NicksFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        BluebirdFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        TapFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        UpstairsFavoriteSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
//        
//        
//        changeText()
//        BrothersFavoriteSwitch.addTarget(self, action: #selector(BroSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText1()
//        KOKFavoriteSwitch.addTarget(self, action: #selector(KOKSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText2()
//        SportsFavoriteSwitch.addTarget(self, action: #selector(KOKSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText3()
//        NicksFavoriteSwitch.addTarget(self, action: #selector(NicksSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText4()
//        BluebirdFavoriteSwitch.addTarget(self, action: #selector(BirdSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText5()
//        TapFavoriteSwitch.addTarget(self, action: #selector(TapSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//        
//        changeText6()
//        UpstairsFavoriteSwitch.addTarget(self, action: #selector(UpstairsSwitchToggled(_:)), for: UIControl.Event.valueChanged)
//    }
//    
//    @IBAction func SaveBrosPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveKOKPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveKSBPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveNEHPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveBluPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveTapPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func SaveUpsPressed(_ sender: UISwitch) {
//        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
//    }
//    
//    @IBAction func BroSwitchToggled(_ sender: UISwitch) {
//        changeText()
//    }
//    
//    func changeText() {
//        if BrothersFavoriteSwitch.isOn {
//            brothersLabel.text = "Added!"
//        } else {
//            brothersLabel.text = ""
//        }
//    }
//    @IBAction func KOKSwitchToggled(_ sender: UISwitch) {
//        changeText1()
//    }
//    
//    func changeText1() {
//        if KOKFavoriteSwitch.isOn {
//            KOKLabel.text = "Added!"
//        } else {
//            KOKLabel.text = ""
//        }
//    }
//    @IBAction func SportsSwitchToggle(_ sender: UISwitch) {
//        changeText2()
//    }
//    
//    func changeText2() {
//        if SportsFavoriteSwitch.isOn {
//            sportsLabel.text = "Added!"
//        } else {
//            sportsLabel.text = ""
//        }
//    }
//    
//    @IBAction func NicksSwitchToggled(_ sender: UISwitch) {
//        changeText3()
//    }
//
//    func changeText3() {
//        if NicksFavoriteSwitch.isOn {
//            nicksLabel.text = "Added!"
//        } else {
//            nicksLabel.text = ""
//        }
//    }
//    @IBAction func BirdSwitchToggled(_ sender: UISwitch) {
//        changeText4()
//    }
//    
//    func changeText4() {
//        if BluebirdFavoriteSwitch.isOn {
//            bluebirdLabel.text = "Added!"
//        } else {
//            bluebirdLabel.text = ""
//        }
//    }
//    @IBAction func TapSwitchToggled(_ sender: UISwitch) {
//        changeText5()
//    }
//    
//    func changeText5() {
//        if TapFavoriteSwitch.isOn {
//            tapLabel.text = "Added!"
//        } else {
//            tapLabel.text = ""
//        }
//    }
//    @IBAction func UpstairsSwitchToggled(_ sender: UISwitch) {
//        changeText6()
//    }
//    
//    func changeText6() {
//        if UpstairsFavoriteSwitch.isOn {
//            upstairsLabel.text = "Added!"
//        } else {
//            upstairsLabel.text = ""
//        }
//    }
//    
//    @IBAction func cancel(_ sender: Any) {
//        print("Cancel button tapped")
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func signUp(_ sender: Any) {
//        print("Sign Up Button Tapped")
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//}
//
//    @IBAction func BackToLoginPressed(_ sender: Any) {
//        func loginView() {
//            
//            DispatchQueue.main.async {
//                let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//                self.present(SignInViewController,animated: true,completion: nil)
//            }
//        }
//        loginView()
//    
//    }//BackToLoginPressed
//}
