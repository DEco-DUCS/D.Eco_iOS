//
//  annotation.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 9/20/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import MapKit
class annotation: NSObject, MKAnnotation{
// added an image property to hold the image once the json is reasdy for images..

    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: String = "32_BigTree"
    var annotationDescription:String?
    
    init(title:String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    init(title:String, subtitle:String, coordinates:CLLocationCoordinate2D,description:String){
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinates
        self.annotationDescription = description
        
    }
    init(title:String, subtitle:String, coordinates:CLLocationCoordinate2D,description:String, annoImage: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinates
        self.annotationDescription = description
        self.image = annoImage
    }








}
