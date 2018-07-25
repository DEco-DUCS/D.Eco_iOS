//
//  TreeDetailsView.swift
//  D.Eco
//
//  Created by fisal Alsabhan on 1/26/18.
//  Copyright © 2018 Fisal Alsabhan. All rights reserved.
//

import UIKit
import MapKit

class TreeDetailsView: UIViewController {
    
    var pressedAnnotation: annotation?
    // outlet to handle the image canvas in the view
    @IBOutlet weak var treeImage: UIImageView!
    // outlet to handle the tree name
    @IBOutlet weak var treeName: UILabel!
    // putlet to handle the subtitle/ scientific name
    @IBOutlet weak var treeSubtitle: UILabel!
    @IBOutlet weak var treeDescription: UITextView!
    var treePassedName: String?
    var treePassedSubtitle: String?
    var treePassedDescription: String?
    var treeImageHolderToDetails:String?
    
    override func viewWillAppear(_ animated: Bool) {
        // code to handel the header image.
        
        //let titleView = UIImageView(image: UIImage(named: "Fixed Deco Header.png"))
        //self.navigationItem.titleView = titleView
        self.navigationItem.title = "Info"
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        treeName.text = "Common Name: \(treePassedName!)"
        treeSubtitle.text = "Scientific Name: \(treePassedSubtitle!)"
        treeDescription.text =  "Description:\n \(treePassedDescription!)"
        if treeImageHolderToDetails != nil{
//            treeImage.image = UIImage(named:treeImageHolderToDetails!)
            
            DispatchQueue.main.async {
               
                let urlString = "http://mcs.drury.edu/deco/imagesREST/FullImages/\(self.treePassedName!).jpg"
                let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: urlEncoded!)
                
                self.treeImage.downloadedFrom(url: url!)
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
