//
//  annotation.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 9/20/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import MapKit
class annotation: NSObject, MKAnnotation{


    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(title:String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }








}
