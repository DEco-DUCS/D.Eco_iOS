//
//  ARViewController.swift
//  
//
//  Created by fisal Alsabhan on 7/28/18.
//

import UIKit
import ARCL
import CoreLocation
@available(iOS 11.0, *)
class ARViewController: UIViewController {
var sceneLocationView = SceneLocationView()
   var locationArrayForTour = [annotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locationArrayForTour.count)
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        navigationItem.title = String(locationArrayForTour.count)
        for i in locationArrayForTour{
       // let coordinate = CLLocationCoordinate2D(latitude: 51.504571, longitude: -0.019717)
            let location = CLLocation(coordinate: (i.coordinate), altitude: 300)
        let image = UIImage(named:"DEco Tree")!
      
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }


}
