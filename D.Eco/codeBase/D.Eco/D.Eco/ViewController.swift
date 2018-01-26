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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // this is a var of type CLplacemark that going to hold the tapped annotation from the user
    var currentPlacemark: CLLocation?
    
    
    @IBAction func directionButton(_ sender: Any) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        let routeArray = [manager.location, currentPlacemark]
      
        
        var convertedRouteArray = routeArray.map{$0!.coordinate}
           
                let geodesic = MKGeodesicPolyline(coordinates: &convertedRouteArray, count: convertedRouteArray.count)
        self.myMap.removeOverlays(self.myMap.overlays)
        self.myMap.add(geodesic)
            
        
        
        
        
    }
    // below is the constrain for the direction button. THE DEFUAL IS SET TO -8; to maintain autoLayout
    
    @IBOutlet weak var directionButtonConstrain: NSLayoutConstraint!
    
  
    
    
    var menuIsHidden: Bool = true

    // a constrains outlet to manage the menu view level of aperance.
    @IBOutlet weak var sideMenuConstrain: NSLayoutConstraint!
    
    // below code tht handles the menu button to open and close the menu.
    @IBAction func sideMenuToggle(_ sender: UIBarButtonItem) {
        if menuIsHidden {
            sideMenuConstrain.constant = 0
            menuIsHidden = false
            UIView.animate(withDuration: 0.45, animations:{ self.view.layoutIfNeeded()})
            
        }else{
            sideMenuConstrain.constant = -150
            menuIsHidden = true
            
             UIView.animate(withDuration: 0.45, animations:{ self.view.layoutIfNeeded()})
           
            
        }
    }
    
    
    
    // blow code to handle the head image and load it before this view appears.
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
   // below is the code to handle the segmented control for the map style...
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
        sideMenuConstrain.constant = -150
        
        print(locationArray)
        manager.delegate = self
        myMap.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
                        // edit start:
        self.myMap.showsUserLocation = true
        self.myMap.addAnnotations(locationArray)
        
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
   
//     implemeting a method to handel the drawing the polyline for the route
//     this is the method when ever the delegate whats to draw something it gets called..
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.brown

        return renderer
    }
    
    
   
    

    



        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? annotation{
          let identifier = "pin"
          var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x:-5,y:5)
                view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                
            }
            return view
        
        
        }
        return nil
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let location = view.annotation as? annotation{
            print("here\(location)")
            self.currentPlacemark = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.directionButtonConstrain.constant = -8
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
         self.directionButtonConstrain.constant = -70
    }
    
    
    
    
    
}




















