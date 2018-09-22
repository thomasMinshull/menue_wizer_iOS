//
//  NetworkManager.swift
//  MenuWise
//
//  Created by thomas minshull on 2018-09-22.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func validateOceanWiseLogo(lat: Double, lon: Double, completion: @escaping (Bool) -> ()) {
        dataTask?.cancel()
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.query = "lat=\(lat)&lon=\(lon)"
        
        guard let url = urlComponents.url else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: {  (data, response, error) in
            guard let data = data else {
                print("Data unable to be unwrapped when validating Ocean Wise Logo. Response: \(String(describing: response)) Error: \(String(describing: error))")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let validator = try? jsonDecoder.decode(Validation.self, from: data)
            
            guard let valid = validator?.valid else {
                print("Unable to deserialize json while validation Ocan Wise Logo.")
                return
            }
            
            completion(valid)
            
        })
        dataTask?.resume()
    }
}
