//
//  splashScreenViewController.swift
//  D.Eco
//
//  Created by fisal Alsabhan on 11/21/17.
//  Copyright © 2017 Fisal Alsabhan. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController, HomeModelDelegate {
    @IBOutlet weak var backGround: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    func itemsDownloadForTour(tourLocation: [annotation]) {
        self.locationArrayForTour = tourLocation
    }
    
    let homeModel = HomeModel()
    let homeModelTwo = HomeModel()
    // maybe i need to add another object to use??? not sure.
   
    
    
    
    func itemsDownloaded(locations: [annotation]) {
        self.locationArray = locations
    }
    
   
    

   var locationArray = [annotation]()
   var locationArrayForTour = [annotation]()
    override func viewDidLoad() { 
        super.viewDidLoad()
       
        homeModel.getItems()
        homeModelTwo.getItemsForRoute()
        homeModel.delegate = self
        homeModelTwo.secondDelegate = self
     Timer.scheduledTimer(timeInterval: 0.05 , target: self, selector: #selector(self.goBar), userInfo: nil, repeats: true)
       
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoSegue), userInfo: nil, repeats: false)
        
        
    }
   
    @objc func autoSegue(){
        
        self.performSegue(withIdentifier: "goToViewController", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToViewController") {
            // pass data to next view
        let navigationViewController: UINavigationController =  segue.destination as! UINavigationController
        let mainViewController = navigationViewController.viewControllers.first as! UIViewController as! ViewController
        
        
        mainViewController.locationArray = locationArray
        mainViewController.locationArrayForTour = locationArrayForTour
            
            
            
        }
    }
    
    @objc func goBar(){
        progressBar.progress += 0.05
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
