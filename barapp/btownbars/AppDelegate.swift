//
//  AppDelegate.swift
//  proficiency-05
//
//  Created by Ashley Wilkeson on 12/8/18.
//  Copyright © 2018 Ashley Wilkeson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

// colors
let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorBrandBlue = UIColor(red: 45 / 255, green: 213 / 255, blue: 255 / 255, alpha: 1)

let fontSize12 = UIScreen.main.bounds.width / 31

//
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//, UNUserNotificationCenterDelegate
    var window: UIWindow?
    
    func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (authorized:Bool, error:Error?) in
            if authorized == false{
                print("You will NOT be notified when you are added to a group.")
            }
            else {
                print("You will recieve notifications when you are added to a group.")
            }
        }
        
        //define actions
        let stayAction = UNNotificationAction(identifier: "staygroup", title: "Stay in the Group", options: [])
        let leaveAction = UNNotificationAction(identifier: "leavegroup", title: "Leave the Group", options: [])

        //add action
        let category = UNNotificationCategory(identifier: "groupCategory", actions: [stayAction, leaveAction], intentIdentifiers: [], options: [])
        
        //add category to framework
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        return true
    }
    
    func scheduleNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Group Notification"
        content.body = "You have been added to a group in Btown Bars."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "groupCategory"
        
        guard let path = Bundle.main.path(forResource: "bbars", ofType: "png")
            else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachement = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachement]
        } catch {
            print("The attachment could not be loaded.")
        }
        
        let request = UNNotificationRequest(identifier: "groupNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // boolean to check is erroView is currently showing or not
    @objc var infoViewIsShowing = false
    
    private func infoapplication(_ infoapplication: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        return true
    }
    
    // infoView view on top
    @objc func infoView(message:String, color:UIColor) {
        
        // if infoView is not showing ...
        if infoViewIsShowing == false {
            
            // cast as infoView is currently showing
            infoViewIsShowing = true
            
            
            // infoView - red background
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
            
            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            
            // infoView - label to show info text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = .white
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            
            // animate info view
            UIView.animate(withDuration: 0.2, animations: {
                
                // move down infoView
                infoView.frame.origin.y = 0
                
                // if animation did finish
            }, completion: { (finished:Bool) in
                
                // if it is true
                if finished {
                    
                    UIView.animate(withDuration: 0.1, delay: 3, options: .curveLinear, animations: {
                        
                        // move up infoView
                        infoView.frame.origin.y = infoView_Y
                        
                        // if finished all animations
                    }, completion: { (finished:Bool) in
                        
                        if finished {
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// EXTRA FUNCTIONS EXTRA FUNCTIONS EXTRA FUNCTIONS EXTRA FUNCTIONS EXTRA FUNCTIONS
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "btownbars")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

