//
//  NetworkService.swift
//  D.Eco
//
//  Created by fisal Alsabhan on 6/20/18.
//  Copyright © 2018 Fisal Alsabhan. All rights reserved.
//

import Foundation
class NetworkService{
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    let url: URL
    
    init(url: URL)
    {
        self.url = url
    }
    
    func downloadImage(comletion:@escaping ((NSData) -> Void) ){
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // secess to download
                if let httpResponse = response as? HTTPURLResponse{
                    switch(httpResponse.statusCode){
                    case 200:
                        if let data = data{
                            comletion(data as NSData)
                        }
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            }else{
                // fail to download
                print("ERORR in downloading the images: \(String(describing: error?.localizedDescription))")
            }
        }
        dataTask.resume()
    }
    
}
