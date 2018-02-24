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


class TFTreeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    /*
     
     This viewcontroller handles the Take a "Tour view". in which it's going to show the user a map with multiple annotations "Pins" as well as the user current locations.
    */
    
    /*
     - it also, handels the start route button, which when the user presses it, it will create a polyline from the user current location to all the of the annotations based apon the distances, so it's going to pick first the closest one to the current location, then from there it will keep on drwing the polyline to the next closest one, all the way to the last annotations.
     - the drawing functionality is all done using one of the mapkit delegation method to render the polyline to desplay it and customize its features, such as the color, width as well as many other thing that could be customized.
    
     */
    @IBAction func button(_ sender: UIButton) {
        
        createPolyline(mapView: self.myMap, PAnnotations: locationArrayForTour)
        self.myMap.showAnnotations(locationArrayForTour, animated: true)
        print(locationArrayForTour,"here is the new json obejt pass throught the viewcontroller ssegue.......")
        
    }
    // this is a test function to check if the annotations are sorted
    func printDistances(take this: [CLLocation]) {
        
        for x in this{
            
            print(manager.location!.distance(from: x))
            
            
        }
        
        
    }
    // this function will sort the annotations from the closet to ... and wil return a sorted array WTF
    private func sortAnnotationsByDistance(take this: [CLLocation]) -> [CLLocation]{
        
        let sortedAnnotations = this.sorted { (left, right) -> Bool in
            
            manager.location!.distance(from: left) < manager.location!.distance(from: right)
        }
        return sortedAnnotations
        
    }

    @IBOutlet weak var myMap: MKMapView!
    
    // declare home model, home model object 
    var locationArrayForTour = [annotation]()
    
 
    let manager = CLLocationManager()
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
    
// mapview delegate funtion to handle user tacking..
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        manager.stopUpdatingLocation()
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
        var newAnnotations:[CLLocation] = [manager.location!]
        
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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        myMap.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        myMap.addAnnotations(locationArrayForTour)
        manager.startUpdatingLocation()
        myMap.setUserTrackingMode(.followWithHeading, animated:false)
        
        
    }
    // CLLocationManager delegate method that handels tracking the user locations, by tracking if the user's locations start to change, and when that happens it starts to update the regin to center the user location in the screen.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
            let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            myMap.setRegion(region, animated: false)
            myMap.mapType = MKMapType.hybridFlyover
            
            
        }
        
        
        
        
        
        
    }
    
    
    
}

