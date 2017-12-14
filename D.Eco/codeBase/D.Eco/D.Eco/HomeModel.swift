//
//  HomeModel.swift
//  D.Eco
//
//  Created by Fisal Alsabhan on 9/23/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.


import UIKit
import MapKit
protocol HomeModelDelegate {
    // this function is what used to store the data as annotations obejets and pass them to another viewcontroller.
    func itemsDownloaded(locations: [annotation])
    func itemsDownloadForTour(tourLocation: [annotation])
}
class HomeModel:NSObject {
    
    var delegate: HomeModelDelegate?
    var secondDelegate: HomeModelDelegate?
    
    func getItems(){
      let serviceUrl = "http://ec2-34-210-220-81.us-west-2.compute.amazonaws.com"
      let url = URL(string: serviceUrl)
        if let url = url{
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil{
                // succeeded
                    self.parseJson(data!)
                
                }else{
                // failed
                print("ERROR OCCURED HERE")
                
                
                }
            })
            task.resume()
            
        }//first if statement end
    

    } // getItem Function end
    
    // this function is for.
    // get the items for the 21 trees used for the route.
    func getItemsForRoute(){
        let serviceUrl = "http://ec2-34-210-220-81.us-west-2.compute.amazonaws.com/index2.php"
        let url = URL(string: serviceUrl)
        if let url = url{
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil{
                    // succeeded
                    self.parseJsonForTour(data!)
                    
                }else{
                    // failed
                    print("ERROR OCCURED HERE")
                    
                    
                }
            })
            task.resume()
            
        }//first if statement end
        
        
    }

    func parseJson(_ data: Data){
        // could not append because annotations are objects.
        var locationArray = [annotation]()
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonObject in jsonArray{
                // creating a dictinary to hold a the value of the JSON object.
                let currentAnnotaionArray: Dictionary = jsonObject as! Dictionary <String,AnyObject>
                // creating the key names to get the dictianry value of the needed value.
                let TITLE_KEY = "common_name"
                let SUBTITLE_KEY = "scientific_name"
                let LATITUDE_KEY = "latitude"
                let LONGITUDE_KEY = "longitude"
                // parse and get the  name and discription.
                let titleString:String = currentAnnotaionArray[TITLE_KEY] as! String
                let subtitleString:String  = currentAnnotaionArray[SUBTITLE_KEY] as! String
                
                // getting the latitude and longitude and force cast it to double type, using doubleValue method.
                let latitudeString:Double = (currentAnnotaionArray[LATITUDE_KEY]?.doubleValue)!
                let longitudeString: Double = (currentAnnotaionArray[LONGITUDE_KEY]?.doubleValue)!
                
                // creating the location from the LATITUDE_KEY and LONGITUDE_KEY, from type CCLOcation2D, which is A structure that contains a geographical coordinate using the WGS 84 reference frame.
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeString, longitudeString)
                // cuurent annotation is an object from the calss annotaion to create the annotaion from the given JSON obejct.
                
              let currentAnnotaion: annotation = annotation(title: titleString, subtitle: subtitleString ,coordinate: location)
            
                
                locationArray.append(currentAnnotaion)
                print(location)
            }// for loop end
            
            // pass the obejct back useing the delegate; 
            delegate?.itemsDownloaded(locations: locationArray)
            

            
    
    
    
        }// do end
        catch{
        print("error in catch block")
        
        }
    
    
    
    
    }// parseJson func end
    func parseJsonForTour(_ data: Data){
        // could not append because annotations are objects.
        var locationArrayForTour = [annotation]()
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonObject in jsonArray{
                // creating a dictinary to hold a the value of the JSON object.
                let currentAnnotaionArray: Dictionary = jsonObject as! Dictionary <String,AnyObject>
                // creating the key names to get the dictianry value of the needed value.
                let TITLE_KEY = "common_name"
                let SUBTITLE_KEY = "scientific_name"
                let LATITUDE_KEY = "latitude"
                let LONGITUDE_KEY = "longitude"
                // parse and get the  name and discription.
                let titleString:String = currentAnnotaionArray[TITLE_KEY] as! String
                let subtitleString:String  = currentAnnotaionArray[SUBTITLE_KEY] as! String
                
                // getting the latitude and longitude and force cast it to double type, using doubleValue method.
                let latitudeString:Double = (currentAnnotaionArray[LATITUDE_KEY]?.doubleValue)!
                let longitudeString: Double = (currentAnnotaionArray[LONGITUDE_KEY]?.doubleValue)!
                
                // creating the location from the LATITUDE_KEY and LONGITUDE_KEY, from type CCLOcation2D, which is A structure that contains a geographical coordinate using the WGS 84 reference frame.
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeString, longitudeString)
                // cuurent annotation is an object from the calss annotaion to create the annotaion from the given JSON obejct.
                
                let currentAnnotaion: annotation = annotation(title: titleString, subtitle: subtitleString ,coordinate: location)
                
                
                locationArrayForTour.append(currentAnnotaion)
                print(location)
            }// for loop end
            
            // pass the obejct back useing the delegate;
            secondDelegate?.itemsDownloadForTour(tourLocation: locationArrayForTour)
            
            
            
            
            
            
        }// do end
        catch{
            print("error in catch block")
            
        }
        
        
        
        
    }


}// class end
