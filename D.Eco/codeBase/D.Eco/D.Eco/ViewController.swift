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
    @objc public func goToDetails(_sender: UIButton){
        
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

    
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? annotation{
            let identifier = "marker"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else{
                
                if #available(iOS 11.0, *) {
                   let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    // another view to hold the addtional data for the call out, such as a label for the subtitle and the description.
                    let calloutCustomView = UIView()
                    let myCustomButton = UIButton(type: .detailDisclosure)
                    myCustomButton.isUserInteractionEnabled = true
                    myCustomButton.frame = CGRect(x: 95, y: 0, width: 20, height: 20)
                    myCustomButton.accessibilityIdentifier = "viewCalloutButton"
                    
                    
                    
                    let calloutWidth = NSLayoutConstraint(item: calloutCustomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant:120)
                    
                    calloutCustomView.addConstraint(calloutWidth)
                    let calloutHeight = NSLayoutConstraint(item: calloutCustomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
                    calloutCustomView.addConstraint(calloutHeight)
                    
 
                    //markerView.glyphText = "⽊"
                    
                   
                    markerView.calloutOffset = CGPoint(x:0,y:0)
                    //markerView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    //markerView.rightCalloutAccessoryView?.frame = CGRect(x:-20, y:-200, width: 30, height: 20)
                   // markerView.rightCalloutAccessoryView?.reloadInputViews()
                    // call the cluster that show the number of inner annotations
                    markerView.clusteringIdentifier = "identifier"
                   // creating the image and swaping the annotations image with it.
                    let annotationImage = annotation.image
                    // creating the image view as a clickable button
                    let imageButton = UIButton(type: .custom)
                    // assigning the frame attributes to locate and resize the defualt right callout
                    imageButton.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                    imageButton.setImage(annotationImage, for: UIControlState())
                    // swaping the image view with the lef tcallout view
                    markerView.leftCalloutAccessoryView = imageButton
                    // assigning a background button with it
                    markerView.leftCalloutAccessoryView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    // label to hold the subtitile in the new view
                    let subtitleLabel = UILabel(frame: CGRect(x: 0, y: -10, width: 80, height: 30))
                    subtitleLabel.text = annotation.subtitle
                    //  subtitleLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    subtitleLabel.adjustsFontSizeToFitWidth = true
                    // another Label to hold the tree description
                    let annotationDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 120, height: 70))
                    annotationDescriptionLabel.numberOfLines = 10
                    //calloutCustomView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    
                    annotationDescriptionLabel.text = "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
                    annotationDescriptionLabel.adjustsFontSizeToFitWidth = true                    //annotationDescriptionLabel.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
                    myCustomButton.addTarget(self, action: #selector(goToDetails), for: .touchUpInside)
                    
                    calloutCustomView.addSubview(annotationDescriptionLabel)
                    calloutCustomView.addSubview(subtitleLabel)
                    calloutCustomView.addSubview(myCustomButton)
                    
                    
                    
                    markerView.detailCalloutAccessoryView = calloutCustomView
                    
                    markerView.canShowCallout = true
                    
                   // markerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    
                    
                    
                    return markerView
                } else {
                    
                    // Fallback on earlier versions
                    
                    view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    view.canShowCallout = true
                    view.calloutOffset = CGPoint(x:-50,y:-50)
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    let annotationImage = annotation.image
                    let imageButton = UIButton(type: .custom)
                    imageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    imageButton.setImage(annotationImage, for: UIControlState())
                    view.leftCalloutAccessoryView = imageButton
                    
                    
                }
           
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
        if control == view.leftCalloutAccessoryView {
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
           myMap.mapType = MKMapType.hybridFlyover
        }
        
        self.myMap.showsUserLocation = true
        
        print("updates")
        
        
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            myMap.remove(polyline)
        }
        
        
        
        
        
        
    }
    
    
    
    
    
}



















