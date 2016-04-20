//
//  NetworkOperation.swift
//  On The Map
//
//  Created by Richard Reed on 3/1/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    lazy var session: NSURLSession = NSURLSession.sharedSession()
    let url: String
    let appID: String
    let apiKey: String
    
    init(url: String, appID: String, apiKey: String) {
        self.url = url
        self.appID = appID
        self.apiKey = apiKey
    }
    
    //MARK: -- Network Operation methods
    
    func downloadJSONFromURL(completion: ([String: AnyObject]?) -> Void) {
        
        let queryURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: queryURL!)
        request.addValue(appID, forHTTPHeaderField: ParseAPI.Constants.parseApplicationId)
        request.addValue(apiKey, forHTTPHeaderField: ParseAPI.Constants.parseRESTAPIKey)
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            // Check for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    // Create JSON object with data
                    let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
                    completion(jsonDictionary)
                    
                default:
                    print("GET request not sucessful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("ERROR: Not a valid HTTP Response")
            }
            
            
        }
        dataTask.resume()
    }



}
    