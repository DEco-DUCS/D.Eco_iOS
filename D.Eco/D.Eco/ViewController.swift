//
//  ViewController.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 4/29/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var segmentedContrl: UISegmentedControl!
    
    @IBAction func segmentedchanged(_ sender: AnyObject){
        switch segmentedContrl.selectedSegmentIndex {
        case 0:
            map.mapType = MKMapType.standard
            break
        case 1:
            map.mapType = MKMapType.satellite
            break
        default:
            break
        }
    
    
    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // map creation and setting the coordinates, region and the zoom lvl.
        let latitude: CLLocationDegrees =  37.2200
        
        let longitude: CLLocationDegrees = -93.2862
        
        let latiDelta:CLLocationDegrees = 0.010
        let longDelta: CLLocationDegrees = 0.010
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta:latiDelta,longitudeDelta: longDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       
        // not sure!!
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location,span:  span)
        map.setRegion(region, animated: true)
    
    // class TreeAnnotation and creating annotation object in the viewController
        let tree1 = TreeAnnotation(title: "Silver Maple", subtitle: "Acer sacharinum, Family ACERACEAE", coordinate: CLLocationCoordinate2D(latitude: 37.218451, longitude: -93.285680 ))
        let tree2 = TreeAnnotation(title: "Basswood", subtitle:"Tiliaamericana, Family MALVACEAE", coordinate:CLLocationCoordinate2DMake(37.221070, -93.285696))
       
        
        let tree3 = TreeAnnotation(title:"Willow", subtitle:"Quercus phellos, Family FAGACEAE", coordinate:CLLocationCoordinate2DMake(37.218217, -93.287392))
        
        
        
        


        let tree4 = TreeAnnotation(title:"Catalpa", subtitle:"catalpa speciosa, Family BIGNONIACEAE", coordinate:CLLocationCoordinate2DMake(37.217409, -93.284849))
        
      
        

        let  tree5 = TreeAnnotation(title:"Sycamore", subtitle:"platanus occidentalis, Family PLATANACEAE", coordinate:CLLocationCoordinate2DMake(37.218960, -93.286120))
            
       
        
        

            map.addAnnotation(tree1)
            map.addAnnotation(tree2)
            map.addAnnotation(tree3)
            map.addAnnotation(tree4)
            map.addAnnotation(tree5)
        
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

