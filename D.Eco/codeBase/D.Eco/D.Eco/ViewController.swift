//
//  ViewController.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 9/18/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// TODO: work on the design now
// done recently, reconstructed the archi of the app.
// done recently, added another storage to the Homemodel class to get the other tree for the tour.
// done recently, created another protocos subclass to store the other json object.

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var menuStatus: Bool = false

    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // code to handel the header image.
        
        let titleView = UIImageView(image: UIImage(named: "Fixed Deco Header.png"))
        self.navigationItem.titleView = titleView
    }
    @IBAction func userLocationRefreash(_ sender: Any) {
        
        self.myMap.setUserTrackingMode(.follow, animated:true)
        
        
        
    }
    // connecting the map from the mainBoard and refering to it as "myMap".....
    @IBOutlet weak var myMap: MKMapView!
   // the array that's recieves that data thought the splash screen segue 
    var locationArray = [annotation]()
    // the second array that stores the other json obejcts to the tree tour.
    // this array will get send throught the segue to the 21 treeviewcontroller.
    var locationArrayForTour = [annotation]()

    

    
    
    let manager = CLLocationManager()
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
        let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        myMap.setRegion(region, animated: true)
        

     
        }
        self.myMap.showsUserLocation = true
        
        manager.stopUpdatingLocation()
    
    
    
    }
   
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentControl(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            myMap.mapType = MKMapType.standard
            break
        case 1:
            myMap.mapType = MKMapType.hybridFlyover
            break
       
        default:
            break
        }

    }

    
    // start get data from Json test code, sep 24th. 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(locationArray)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
                        // edit start:
        self.myMap.showsUserLocation = true
        myMap.addAnnotations(locationArray)
        myMap.setUserTrackingMode(.follow, animated:true)
      
    }
   // this function will get called whenever this view controller is about to segue to another viewcontoller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToTFTreeViewController"){
            let mainViewController: TFTreeViewController = segue.destination as! TFTreeViewController
            
            mainViewController.locationArrayForTour = locationArrayForTour
            mainViewController.locationArray = locationArray
        }
        
    }
    
    
   
    

    



        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
