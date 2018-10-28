//
//  21FirstTreeViewController.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 11/13/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class TFTreeViewController: UIViewController, CLLocationManagerDelegate {
    /*
     
     This viewcontroller handles the Take a "Tour view". in which it's going to show the user a map with multiple annotations "Pins" as well as the user current locations.
     */
    
    /*
     - it also, handels the start route button, which when the user presses it, it will create a polyline from the user current location to all the of the annotations based apon the distances, so it's going to pick first the closest one to the current location, then from there it will keep on drwing the polyline to the next closest one, all the way to the last annotations.
     - the drawing functionality is all done using one of the mapkit delegation method to render the polyline to desplay it and customize its features, such as the color, width as well as many other thing that could be customized.
     
     */
    // data that hold the pressed annotations data to store it and use it to pass the data to the detail view page
    var treeNameToDetails:String?
    var treeSubtitleToDetails:String?
    var treeDescriptionToDetails:String?
    var treeImageHolderToDetails: String?
    
    
    @objc public func goToDetails(_sender: UIButton){
        
        self.performSegue(withIdentifier: "goToDetailsPage", sender: self)
        
    }
    
    
    @IBAction func newbutton(_ sender: Any) {
        
        createPolyline(mapView: self.myMap, PAnnotations: locationArrayForTour)
        self.myMap.showAnnotations(locationArrayForTour, animated: true)
        
    }
    
    
    // this is a test function to check if the annotations are sorted
    func printDistances(take this: [CLLocation]) {
        
        for x in this{
            
            print(locationManager.location!.distance(from: x))
            
        }
        
    }
    // this function will sort the annotations from the closet to ... and wil return a sorted array WTF
    private func sortAnnotationsByDistance(take this: [CLLocation]) -> [CLLocation]{
        
        let sortedAnnotations = this.sorted { (left, right) -> Bool in
            
            locationManager.location!.distance(from: left) < locationManager.location!.distance(from: right)
        }
        return sortedAnnotations
        
    }
    
    @IBOutlet weak var myMap: MKMapView!
    
    // declare home model, home model object 
    var locationArrayForTour = [annotation]()
    
    
    let locationManager = CLLocationManager()
    private var coordinates = [CLLocation]()
    // mapview function that create the renderer for the polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rederer  = MKPolylineRenderer(overlay: overlay)
        rederer.strokeColor = UIColor.blue
        rederer.lineWidth = 5
        return rederer
    }
    
    
    //func converAnnotaionToCLLocation take the array of annotaions and convert it to an array of CLLocations value, so later we can calculate the distances between the annotaions
    private func converAnnotaionToCLLocation(change thisArray: [annotation]) -> [CLLocation] {
        // array that's going to hold the annotaion's CLLocations info to run in the background........
        var cLLArray = [CLLocation]()
        // checks if the pass array from the paramater is not empty......
        if thisArray.count != 0{
            for i in thisArray{
                
                cLLArray.append(CLLocation(latitude: i.coordinate.latitude, longitude: i.coordinate.longitude))
                
            }
            
            return cLLArray
        } else{
            
            
            return cLLArray
        }
        
    }
    
    
    
    
    // functions that returns the colsest annotation to user locations
    
    private func getClosestLocation(user location: CLLocation,arrayOf locations: [CLLocation]) -> CLLocation? {
        var closestLocation: (distance: Double, coordinates: CLLocation)?
        
        for loc in locations {
            let distance = round(location.distance(from: loc))  as Double
            if closestLocation == nil {
                closestLocation = (distance, loc)
            } else {
                if distance < closestLocation!.distance {
                    closestLocation = (distance, loc)
                }
            }
        }
        return closestLocation?.coordinates
    }
    
    
    func createPolyline(mapView: MKMapView, PAnnotations: [annotation]) {
        // an array the containts the annotations in CLLocation type to get access to calculate. 
        var newAnnotations:[CLLocation] = [locationManager.location!]
        
        var CLLocationArray = converAnnotaionToCLLocation(change: PAnnotations)
        for (index,_) in CLLocationArray.enumerated(){
            let closestAnnotaion = getClosestLocation(user: newAnnotations[index], arrayOf: CLLocationArray)
            newAnnotations.append(closestAnnotaion!)
            let removedAnnotationIndex = CLLocationArray.index(of: closestAnnotaion!)
            CLLocationArray.remove(at: removedAnnotationIndex!)
            
        }
        var sortedArrayForDrawing = newAnnotations.map{$0.coordinate}
        let geodesic = MKGeodesicPolyline(coordinates: &sortedArrayForDrawing, count: sortedArrayForDrawing.count)
        self.myMap.removeOverlays(self.myMap.overlays)
        self.myMap.add(geodesic)
        
    }
    
    
    // mapKit delegate method to handel drawing the overlay
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.brown
        
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToDetailsPage"){
            let nextViewController: TreeDetailsView = segue.destination as! TreeDetailsView
            nextViewController.treePassedName = self.treeNameToDetails
            nextViewController.treePassedSubtitle = self.treeSubtitleToDetails
            nextViewController.treePassedDescription = self.treeDescriptionToDetails
            nextViewController.treeImageHolderToDetails = self.treeImageHolderToDetails
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // code to handel the header image.
        
        //let titleView = UIImageView(image: UIImage(named: "Fixed Deco Header.png"))
        //self.navigationItem.titleView = titleView
        self.navigationItem.title = "21 Tour Tree"
        
        
        
    }
    public func mapSetUp(){
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
        let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        myMap.setRegion(region, animated: true)
        myMap.mapType = .hybrid
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        myMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapSetUp()
        myMap.addAnnotations(locationArrayForTour)
        // manager.startUpdatingLocation()
        myMap.setUserTrackingMode(.followWithHeading, animated:false)
        myMap.mapType = .hybrid
        
        
    }
    // CLLocationManager delegate method that handels tracking the user locations, by tracking if the user's locations start to change, and when that happens it starts to update the regin to center the user location in the screen.
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        if let location  = locations.last {
    //
    //
    //            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
    //            let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    //            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
    //            myMap.setRegion(region, animated: false)
    //
    //
    //        }
    //
    //
    //
    //
    //    }
    
    
    
}


// an extention that coforms to the mapView delegate
extension TFTreeViewController: MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        if let annotation = annotation as? annotation{
            let identifier = "marker"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                dequeuedView.annotation = annotation
                if view == nil{
                    print("empty view")
                    view = dequeuedView
                }
                
                if #available(iOS 11.0, *) {
                    let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    // another view to hold the addtional data for the call out, such as a label for the subtitle and the description.
                    let calloutCustomView = UIView()
                    let myCustomButton = UIButton(type: .detailDisclosure)
                    //myCustomButton.isUserInteractionEnabled = true
                    myCustomButton.frame = CGRect(x: 95, y: 0, width: 20, height: 20)
                    myCustomButton.accessibilityIdentifier = "viewCalloutButton"
                    
                    
                    //myCustomButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    let calloutWidth = NSLayoutConstraint(item: calloutCustomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant:120)
                    
                    calloutCustomView.addConstraint(calloutWidth)
                    let calloutHeight = NSLayoutConstraint(item: calloutCustomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
                    calloutCustomView.addConstraint(calloutHeight)
                    
                    //markerView.glyphText = "⽊"
                    
                    
                    markerView.calloutOffset = CGPoint(x:0,y:0)
                    
                    markerView.clusteringIdentifier = "identifier"
                    // creating the image and swaping the annotations image with it.
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //                    let annotationImage = UIImage(named:annotation.image)
                    //                    // creating the image view as a clickable button
                    //                    let imageButton = UIButton(type: .custom)
                    //                    // assigning the frame attributes to locate and resize the defualt right callout
                    //                    imageButton.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                    //                    imageButton.setImage(annotationImage, for: UIControlState())
                    //                    // swaping the image view with the lef tcallout view
                    //                    markerView.leftCalloutAccessoryView = imageButton
                    ////                    // assigning a background button with it
                    //                    markerView.leftCalloutAccessoryView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    // label to hold the subtitile in the new view
                    let subtitleLabel = UILabel(frame: CGRect(x: 0, y: -10, width: 80, height: 30))
                    subtitleLabel.text = annotation.subtitle
                    //  subtitleLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    subtitleLabel.adjustsFontSizeToFitWidth = true
                    // another Label to hold the tree description
                    let annotationDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 120, height: 70))
                    annotationDescriptionLabel.numberOfLines = 5
                    //calloutCustomView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    
                    annotationDescriptionLabel.text = annotation.annotationDescription
                    // annotationDescriptionLabel.adjustsFontSizeToFitWidth = true                    //annotationDescriptionLabel.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
                    myCustomButton.addTarget(self, action: #selector(goToDetails), for: .touchUpInside)
                    annotationDescriptionLabel.adjustsFontSizeToFitWidth = false
                    annotationDescriptionLabel.font = UIFont.systemFont(ofSize: 9.0)
                    //annotationDescriptionLabel.font = UIFont(name: "identifier", size: 1)
                    calloutCustomView.addSubview(annotationDescriptionLabel)
                    calloutCustomView.addSubview(subtitleLabel)
                    calloutCustomView.addSubview(myCustomButton)
                    
                    
                    
                    
                    markerView.detailCalloutAccessoryView = calloutCustomView
                    markerView.canShowCallout = true
                    
                    
                    
                    
                    
                    return markerView
                    
                    
                }
            }else{
                
                if #available(iOS 11.0, *) {
                    let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    // another view to hold the addtional data for the call out, such as a label for the subtitle and the description.
                    let calloutCustomView = UIView()
                    let myCustomButton = UIButton(type: .detailDisclosure)
                    //myCustomButton.isUserInteractionEnabled = true
                    myCustomButton.frame = CGRect(x: 95, y: 0, width: 20, height: 20)
                    myCustomButton.accessibilityIdentifier = "viewCalloutButton"
                    
                    
                    //myCustomButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    let calloutWidth = NSLayoutConstraint(item: calloutCustomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant:120)
                    
                    calloutCustomView.addConstraint(calloutWidth)
                    let calloutHeight = NSLayoutConstraint(item: calloutCustomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
                    calloutCustomView.addConstraint(calloutHeight)
                    
                    
                    //markerView.glyphText = "⽊"
                    
                    
                    markerView.calloutOffset = CGPoint(x:0,y:0)
                    
                    markerView.clusteringIdentifier = "identifier"
                    // creating the image and swaping the annotations image with it.
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //                    let annotationImage = UIImage(named:annotation.image)
                    //                    // creating the image view as a clickable button
                    //                    let imageButton = UIButton(type: .custom)
                    //                    // assigning the frame attributes to locate and resize the defualt right callout
                    //                    imageButton.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                    //                    imageButton.setImage(annotationImage, for: UIControlState())
                    //                    // swaping the image view with the lef tcallout view
                    //                   markerView.leftCalloutAccessoryView = imageButton
                    ////                    // assigning a background button with it
                    //                    markerView.leftCalloutAccessoryView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    // label to hold the subtitile in the new view
                    let subtitleLabel = UILabel(frame: CGRect(x: 0, y: -10, width: 80, height: 30))
                    subtitleLabel.text = annotation.subtitle
                    //  subtitleLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    subtitleLabel.adjustsFontSizeToFitWidth = true
                    // another Label to hold the tree description
                    let annotationDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 120, height: 70))
                    annotationDescriptionLabel.numberOfLines = 5
                    //calloutCustomView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    
                    annotationDescriptionLabel.text = annotation.annotationDescription
                    // annotationDescriptionLabel.adjustsFontSizeToFitWidth = true                    //annotationDescriptionLabel.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
                    myCustomButton.addTarget(self, action: #selector(goToDetails), for: .touchUpInside)
                    annotationDescriptionLabel.adjustsFontSizeToFitWidth = false
                    annotationDescriptionLabel.font = UIFont.systemFont(ofSize: 9.0)
                    //annotationDescriptionLabel.font = UIFont(name: "identifier", size: 1)
                    calloutCustomView.addSubview(annotationDescriptionLabel)
                    calloutCustomView.addSubview(subtitleLabel)
                    calloutCustomView.addSubview(myCustomButton)
                    
                    
                    
                    
                    markerView.detailCalloutAccessoryView = calloutCustomView
                    markerView.canShowCallout = true
                    
                    
                    
                    
                    
                    return markerView
                    
                    
                } else {
                    
                    // Fallback on earlier versions
                    
                    //                    view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    //                    view.canShowCallout = true
                    //                    view.calloutOffset = CGPoint(x:-50,y:-50)
                    //                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    //                    let annotationImage = annotation.image
                    //                    let imageButton = UIButton(type: .custom)
                    //                    imageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    //                    imageButton.setImage(annotationImage, for: UIControlState())
                    //                    view.leftCalloutAccessoryView = imageButton
                    
                    
                }
                
            }
            
            
            
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let location = view.annotation as? annotation{
            
            self.treeNameToDetails = (location.title)!
            self.treeSubtitleToDetails = (location.subtitle)!
            let description = view.detailCalloutAccessoryView?.subviews[0]
            self.treeImageHolderToDetails = location.image
            
            
            // using the main thread to download the image icon in demand 
            DispatchQueue.global(qos: .userInitiated).async {
                // Download file or perform expensive task
                // deco/imagesREST/FullImages
                let urlString = "http://mcs.drury.edu/deco/imagesREST/thumpnails/\(location.title!).jpg"
                let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: urlEncoded!)
                print(urlString)
                print(url)
                if url != nil{
                    let downloadService = NetworkService(url: url!)
                    downloadService.downloadImage { (data) in
                        let calloutImage = UIImage(data: data as Data)
                        DispatchQueue.main.async {
                            // Update the UI
                            let imageButton = UIButton()
                            imageButton.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                            imageButton.setImage(calloutImage, for: UIControlState())
                            view.leftCalloutAccessoryView = imageButton
                            //view.leftCalloutAccessoryView?.reloadInputViews()
                        }
                    }
                }
                
            }
            
            
            
            // assigning the labeles to pressed annotations
            if description is UILabel{
                let desLabel = description as! UILabel
                let descriptionText = desLabel.text
                if descriptionText != nil{
                    self.treeDescriptionToDetails = descriptionText
                    
                    
                }
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        self.treeDescriptionToDetails = ""
        self.treeNameToDetails = ""
        self.treeSubtitleToDetails = ""
        self.treeImageHolderToDetails = ""
    }
    
    
    
    
    
    
    
}

