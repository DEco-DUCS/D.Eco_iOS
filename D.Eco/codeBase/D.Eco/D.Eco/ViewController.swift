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
    var treeDescriptionToDetails:String?
    var treeImageHolderToDetails:String?
    var calloutImage: UIImageView?
    // test
    
    // this is a var of type CLplacemark that going to hold the tapped annotation from the user
    var currentPlacemark: CLLocation?
    // set constrains to 0 to make it disappear. and 45 to show
    @IBOutlet weak var cancelRouteButtonConstrains: NSLayoutConstraint!
    // a funtion that performs segues to the details page for the annotation.
    @objc public func goToDetails(_sender: UIButton){
        
        self.performSegue(withIdentifier: "goToDetailsPage", sender: self)
        
    }
    
    
    // direction button
    // apears when user touch an annotation
    // once it's tapped it will create a route from the user current locaton to the tapped annotation
    
    @IBAction func cancelRouteButton(_ sender: UIButton) {
        self.cancelRouteButtonConstrains.constant = 0
        manager.stopUpdatingLocation()
        self.myMap.removeOverlays(self.myMap.overlays)
            }
    
    @IBAction func directionButton(_ sender: Any) {
       manager.startUpdatingLocation()
        
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
            menuIsHidden = !menuIsHidden
            
            UIView.animate(withDuration: 0.45, animations:{ self.view.layoutIfNeeded()})
            
        }else{
            sideMenuConstrain.constant = -150
            menuIsHidden = !menuIsHidden
            
            UIView.animate(withDuration: 0.45, animations:{ self.view.layoutIfNeeded()})
            
            
        }
    }
    
    
    
    // blow code to handle the head image and load it before this view appears.
    override func viewWillAppear(_ animated: Bool) {
        // code to handel the header image.
        
        //let titleView = UIImageView(image: UIImage(named: "Fixed Deco Header.png"))
        //self.navigationItem.titleView = titleView
        self.navigationItem.title = "D.Eco"
    
    
        
    }
    @IBAction func userLocationRefreash(_ sender: Any) {
        
        //manager.startUpdatingLocation()
         myMap.setUserTrackingMode(.follow, animated:true)
        
        
        
        
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
  
    public func mapSetUp(){
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0075,longitudeDelta: 0.0075)
        let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        myMap.setRegion(region, animated: true)
        myMap.mapType = .hybrid
        
        
        
    }
    
    // start get data from Json test code, sep 24th. 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view, typically from a nib.
        sideMenuConstrain.constant = -150
        cancelRouteButtonConstrains.constant = 0
       
        
        
        manager.delegate = self
        myMap.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // edit start:
        self.myMap.showsUserLocation = true
        self.myMap.addAnnotations(locationArray)
        
        myMap.setUserTrackingMode(.follow, animated:true)
        
        
        mapSetUp()
        
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
            nextViewController.treePassedDescription = self.treeDescriptionToDetails
            if treeImageHolderToDetails != nil{
                nextViewController.treeImageHolderToDetails = self.treeImageHolderToDetails
            }
            
        }
          if #available(iOS 11.0, *) {
        if segue.identifier == "ARViewControllerID" {
          
//            let ARViewController: ARViewController = (segue.destination as? ARViewController)!
//                ARViewController.locationArrayForTour = self.locationArrayForTour
//                print(self.locationArrayForTour.count)
            }
            
        }
            
            
            
            
            
        
        
        
    }
    // comment to test github
    
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
            self.currentPlacemark = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.directionButtonConstrain.constant = -8
            self.treeNameToDetails = (location.title)!
            self.treeSubtitleToDetails = (location.subtitle)!
            let description = view.detailCalloutAccessoryView?.subviews[0]
            self.treeImageHolderToDetails = location.image

            
            
            DispatchQueue.global(qos: .userInitiated).async {
                // Download file or perform expensive task
                let urlString = "http://mcs.drury.edu/deco/imagesREST/thumpnails/\(location.title!).jpg"
                let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: urlEncoded!)

                let downloadService = NetworkService(url: url!)
                downloadService.downloadImage { (data) in
                    let calloutImage = UIImage(data: data as Data)
                   
                    
                    
                    
                    DispatchQueue.main.async {
                        // Update the UI
                       let imageButton = UIButton()
                        imageButton.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                        imageButton.setImage(calloutImage, for: UIControl.State())
                        view.leftCalloutAccessoryView = imageButton
                        //view.leftCalloutAccessoryView?.reloadInputViews()
                    }
                }

            }
            
      

            
            
            
           
        
            
            
            
           
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
        self.directionButtonConstrain.constant = -70
        self.treeDescriptionToDetails = ""
        self.treeNameToDetails = ""
        self.treeSubtitleToDetails = ""
        self.treeImageHolderToDetails = ""
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            self.performSegue(withIdentifier: "goToDetailsPage", sender: self)

        }
       
    }
    
  
    
    
   
}

extension ViewController: CLLocationManagerDelegate{
    
    // TODO: fix this for single routing 
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.directionButtonConstrain.constant = -70
//        self.cancelRouteButtonConstrains.constant = 45
//        guard let currentPlacemark = currentPlacemark else {
//            return
//        }
//        let routeArray = [locations.last, currentPlacemark]
//
//
//        var convertedRouteArray = routeArray.map{$0!.coordinate}
//
//        let geodesic = MKGeodesicPolyline(coordinates: &convertedRouteArray, count: convertedRouteArray.count)
//
//
//        myMap.removeOverlays(self.myMap.overlays)
//        self.polylineContainer = geodesic
//        self.myMap.add(self.polylineContainer!)
//        // finish what you started here ->  myMap.overlays.
//
//
//    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            myMap.removeOverlay(polyline)
        }
        
        
        
        
        
        
    }
    
    
    
    
    
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
















