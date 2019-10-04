//
//  mapViewController.swift
//  proficiency-05
//
//  Created by Ashley Wilkeson on 2/6/19.
//  Copyright © 2019 Ashley Wilkeson. All rights reserved.
//

import UIKit
import MapKit


class mapViewController: UIViewController, CLLocationManagerDelegate {
    
        @IBOutlet weak var mapView: MKMapView!
    
    var barName: String!
    var address: String!
    var latitude: String!
    var longitude: String!
    var image: String!
    
    var locationManager = CLLocationManager()
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        
        let locationManager = CLLocationManager()
        func checkLocationAuthorizationStatus() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            checkLocationAuthorizationStatus()
        }
    } //func

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialData()
//        mapView.addAnnotations(all_bars)
        
        // inital location: Bloomington
        let initialLocation = CLLocation(latitude: 39.167142, longitude: -86.530640)
        
        let regionRadius: CLLocationDistance = 800
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self

        createArray()
    
    } //viewdidload
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _:CLLocationCoordinate2D = manager.location!.coordinate
//        print("Locations = \(locValue.latitude) \(locValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600,longitudinalMeters: 600)
        self.mapView.setRegion(viewRegion, animated: true)
    }

    var barlat: Float!
    var barlng: Float!

    func createArray() {
//        var barlat: Float!
//        var barlng: Float!

        let url = URL(string: "http://cgi.sice.indiana.edu/~team68/mapview.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "barName=\(barName ?? "")" // which is your parameter
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with:  request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonData = try? JSONSerialization.jsonObject(with:data, options: [])

                for item in jsonData as! [Dictionary<String, AnyObject>] {
//                    print(item)
                    for userdata in item {
//                        print(userdata)

                        let barname = "bar_name"
                        let address = "location"
                        let lat = "lat"
                        let lng = "lng"

                        if barname == userdata.key {
                            self.barName = userdata.value as? String
                        }
                        if address == userdata.key {
                            self.address = userdata.value as? String
                        }
                        if lat == userdata.key {
                            self.latitude = userdata.value as? String
                        }
                        if lng == userdata.key {
                            self.longitude = userdata.value as? String
                        }
                
                    } //for

                    if self.barName == "The Upstairs Pub" {
                        self.image = "upstairslogo"
                    }
                    if self.barName == "Kilroy's on Kirkwood" {
                        self.image = "Kilroys-Bloomington-KOK-Logo"
                    }
                    if self.barName == "Brother's Bar & Grill" {
                        self.image = "Brothers-logo-black"
                    }
                    if self.barName == "Nick's English Hut" {
                        self.image = "nickslogo"
                    }
                    if self.barName == "The Tap" {
                        self.image = "Kilroys-Bloomington-KOK-Logo"
                    }
                    if self.barName == "The Bluebird" {
                        self.image = "bluebirdlogo"
                    }
                    if self.barName == "Kilroy's Sports Bar" {
                        self.image = "sportslogo"
                    }
                    

                    let bar = Bars(title: self.barName,
                     locationName: self.address, discipline: "Bar",
                     coordinate: CLLocationCoordinate2D (latitude: Double(self.latitude!)!, longitude: Double(self.longitude!)!), image: self.image
                    )
                    self.mapView.addAnnotation(bar)
                    
               } //for

        }  catch {
            print(error)
             }//do
        }//task
        task.resume()
    } //func
    
} //class




extension mapViewController: MKMapViewDelegate {
    
        // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Bars else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.isEnabled = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
//            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
//                                                    size: CGSize(width: 30, height: 30)))
//            mapsButton.setBackgroundImage(UIImage(named: image), for: UIControl.State())
//            view.rightCalloutAccessoryView = mapsButton

            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
        } //func
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let bar = view.annotation as! Bars
        let barName = bar.title
        
        if (barName == "Kilroy's on Kirkwood") {
            DispatchQueue.main.async {

                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [4]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "The Upstairs Pub") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [5]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "Brothers Bar & Grill") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [6]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "Nick's English Hut") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [7]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "Kilroy's Sports Bar") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [8]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "The Bluebird") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [9]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
        if (barName == "The Tap") {
            DispatchQueue.main.async {
                
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! mainTabBarController
                mainTabBarController.selectedViewController = mainTabBarController.viewControllers! [10]
                self.present(mainTabBarController,animated: true, completion: nil)
            }
        }
    }
    
    } //extension



