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

// finished the sprting and converting function

// TODO: when done with  sorting the annotations the most effeint way, then check the bookmarks for swift draw a line to proper implementtation for handling the coordinates from the annotations, without the need to convert them to CLLocations.coordinates.... annotations.coorodantes // done
//TODO: done with refreshing the CreatePolyline function that it updates the route when route button is used. // done
// TODO: reimplement the add line function when it remove the tail polyline behind the user location..// done
class TFTreeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
    
    
    
    
    // call the func itemsDownloaded from HomeModel Class to have the annaotaions array
//    func itemsDownloaded(locations: [annotation]) {
//        self.locationArray = locations
//
//        myMap.addAnnotations(locationArray)
//
//    }
    
 
    @IBOutlet weak var myMap: MKMapView!
    
    // declare home model, home model object 
    var locationArrayForTour = [annotation]()
    // for all treees to send mabck throught the segue.....
    var locationArray = [annotation]()
    var homeModel = HomeModel()
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
            
        }// close for statement loops through annations array.....
        
        return cLLArray
        } else{
            
         
            return cLLArray
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goBackViewController"){
            let mainViewController: ViewController = segue.destination as! ViewController
            
            mainViewController.locationArrayForTour = locationArrayForTour
            mainViewController.locationArray = locationArray
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
   
    
    // this function is call when the polyline will be added to the mapview.
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
    
        
    
    
    // this function will get the directions for the closest route, by also calling the getClosestLocation
    
    // coomented to find another way of doing the sorting..
    
    
    
//    private func getDirections(_ fromLocation: CLLocation, toLocation: CLLocation){
//
//
//        let fromLocationItem = MKMapItem(placemark: MKPlacemark(coordinate: fromLocation.coordinate, addressDictionary: nil))
//        let toLocationItem = MKMapItem(placemark: MKPlacemark(coordinate: toLocation.coordinate, addressDictionary: nil))
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.transportType = .walking
//        directionRequest.source = fromLocationItem
//        directionRequest.destination = toLocationItem
//
//
//        // start directions
//        let directions = MKDirections(request: directionRequest)
//        directions.calculate { (directionsResponse, error) -> Void in
//            if let error = error {
//                print("Error getting directions: \(error.localizedDescription)")
//            } else {
//                let route = directionsResponse?.routes[0] as! MKRoute
//                // draw the route in the map
//                self.myMap.add(route.polyline)
//
//                // get the next closest location
//                let closestLocation = self.getClosestLocation(location: toLocation, locations: self.coordinates)
//                if let closest = closestLocation {
//                    self.getDirections(toLocation, toLocation: closest)
//                }
//
//                // remove the current location's coordinates from the array
//                self.coordinates = self.coordinates.filter({ $0 != toLocation})
//            }
//
//
//
//
//
//
//
//
//
//    }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        homeModel.getItems()
//        homeModel.delegate = self
        myMap.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        myMap.addAnnotations(locationArrayForTour)
        manager.startUpdatingLocation()
        myMap.setUserTrackingMode(.followWithHeading, animated:false)
    
            //        self.myMap.showsUserLocation = true
            
            manager.stopUpdatingLocation()
        }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0075,0.0075)
            let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            myMap.setRegion(region, animated: false)
            
            
        }
        
        
        
        
    }

    
    
   
  
    
  

    




    
    
    

    
    
    
    
    
    
    
    

}// class end

