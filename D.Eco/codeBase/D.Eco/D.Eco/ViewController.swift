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



class ViewController: UIViewController {
    var polylineContainer: MKPolyline?
    var treeNameToDetails:String?
    var treeSubtitleToDetails:String?
    
    // this is a var of type CLplacemark that going to hold the tapped annotation from the user
    var currentPlacemark: CLLocation?
    
    // a funtion that performs segues to the details page for the annotation. 
    public func goToDetails(){
        
        self.performSegue(withIdentifier: "goToDetailsPage", sender: self)
        
    }
    // direction button
    // apears when user touch an annotation
    // once it's tapped it will create a route from the user current locaton to the tapped annotation
    
    @IBAction func directionButton(_ sender: Any) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        let routeArray = [manager.location, currentPlacemark]
        
        
        var convertedRouteArray = routeArray.map{$0!.coordinate}
        
        let geodesic = MKGeodesicPolyline(coordinates: &convertedRouteArray, count: convertedRouteArray.count)
        self.myMap.removeOverlays(self.myMap.overlays)
        self.polylineContainer = geodesic
        self.myMap.add(self.polylineContainer!)
        
        
        
        
        
        
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
        
        manager.startUpdatingLocation()
        
        
        
    }
    // connecting the map from the mainBoard and refering to it as "myMap".....
    @IBOutlet weak var myMap: MKMapView!
    // the array that's recieves that data thought the splash screen segue
    var locationArray = [annotation]()
    // the second array that stores the other json obejcts to the tree tour.
    // this array will get send throught the segue to the 21 treeviewcontroller.
    var locationArrayForTour = [annotation]()
    
    
    
    
    
    let manager = CLLocationManager()
    
    
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
        
        
        manager.delegate = self
        myMap.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        // edit start:
        self.myMap.showsUserLocation = true
        self.myMap.addAnnotations(locationArray)
        
        myMap.setUserTrackingMode(.follow, animated:true)
        manager.startUpdatingLocation()
        
    }
    // this function will get called whenever this view controller is about to segue to another viewcontoller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToTFTreeViewController"){
            let mainViewController: TFTreeViewController = segue.destination as! TFTreeViewController
            
            mainViewController.locationArrayForTour = locationArrayForTour
            
        }
        if(segue.identifier == "goToDetailsPage"){
            let nextViewController: TreeDetailsView = segue.destination as! TreeDetailsView
            nextViewController.treePassedName = self.treeNameToDetails
            nextViewController.treePassedSubtitle = self.treeSubtitleToDetails
            nextViewController.pressedAnnotation = annotation(title: self.treeNameToDetails!, subtitle: self.treeSubtitleToDetails!, coordinate: (self.currentPlacemark?.coordinate)!)
            
            
        }
        
    }
    
    //     implemeting a method to handel the drawing the polyline for the route
    //     this is the method when ever the delegate whats to draw something it gets called..
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 4.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // code here.....
    
}
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? annotation{
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x:-5,y:5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                let annotationImage = annotation.image
                let imageButton = UIButton(type: .custom)
                imageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                imageButton.setImage(annotationImage, for: UIControlState())
                view.leftCalloutAccessoryView = imageButton
                
                
                
                
                
            }
            return view
            
            
        }
        return nil
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let location = view.annotation as? annotation{
            
            self.currentPlacemark = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.directionButtonConstrain.constant = -8
            self.treeNameToDetails = (view.annotation?.title)!
            self.treeSubtitleToDetails = (view.annotation?.subtitle)!
            
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.directionButtonConstrain.constant = -70
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "goToDetailsPage", sender: self)
            
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.stopUpdatingLocation()
    }
    
    
    
}


extension ViewController: CLLocationManagerDelegate{
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
            let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            myMap.setRegion(region, animated: true)
            //            let polyRemovedLocation = [location.coordinate]
            //            let polyLine = MKPolyline(coordinates: polyRemovedLocation, count: polyRemovedLocation.count)
            //            self.myMap.remove(polyLine)
        }
        
        self.myMap.showsUserLocation = true
        
        print("updates")
        
        
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            var polyline = MKPolyline(coordinates: &area, count: area.count)
            myMap.remove(polyline)
        }
        
        
        
        
        
        
    }
    
    
    
    
    
}



















