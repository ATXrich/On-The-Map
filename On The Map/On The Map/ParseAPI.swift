//
//  ParseAPI.swift
//  On The Map
//
//  Created by Richard Reed on 2/15/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation


class ParseAPI {
    
    var studentLocations: [StudentInformation] = []
    
    
    // MARK: - Parse API methods
    
    func getStudentLocation(completion: ([StudentInformation]? -> Void)) {
        
        let getNetworkOperation = NetworkOperation(url: ParseAPI.Constants.parseGetURL, appID: ParseAPI.Constants.parseAppID, apiKey: ParseAPI.Constants.parseAPIKey)
        
        getNetworkOperation.downloadJSONFromURL { (let JSONDictionary) -> Void in
            if let resultsArray = JSONDictionary![ParseAPI.JSONResponseKeys.results] as? [[String: AnyObject]] {
                var students = [StudentInformation]()
                for student in resultsArray {
                    if let studentObject = self.studentFromtJSONObject(student) {
                        students.append(studentObject)
                    }
                }
                if students.count == 0 && resultsArray.count > 0 {
                    print("no data in array")
                }
                completion(students)
            }
        }
    }
    
   
    
    func postStudentLocation(uniqueID: String, firstName: String, lastName: String, mediaURL: String, locationString: String, locationLatitude: String, locationLongitude: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: ParseAPI.Constants.parsePostURL)!)
        request.HTTPMethod = "POST"
        request.addValue(ParseAPI.Constants.parseAppID, forHTTPHeaderField: ParseAPI.Constants.parseApplicationId)
        request.addValue(ParseAPI.Constants.parseAPIKey, forHTTPHeaderField: ParseAPI.Constants.parseRESTAPIKey)
        request.addValue(ParseAPI.Constants.parseAppJson, forHTTPHeaderField: ParseAPI.Constants.parseContentType)
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(locationLatitude), \"longitude\": \(locationLongitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "The internet connection appears to be offline")
            } else {
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if parsedResult["createdAt"] != nil {
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "An unknown error occurred")
                }
            }
        }
        task.resume()
    }

  
    private func studentFromtJSONObject(json: [String:AnyObject]) -> StudentInformation? {
        guard
            let firstName = json[ParseAPI.JSONResponseKeys.firstName] as? String,
            let lastName = json[ParseAPI.JSONResponseKeys.lastName] as? String,
            let latitude = json[ParseAPI.JSONResponseKeys.latitude] as? Float,
            let longitude = json[ParseAPI.JSONResponseKeys.longitude] as? Float,
            let mapString = json[ParseAPI.JSONResponseKeys.mapString] as? String,
            let mediaURL = json[ParseAPI.JSONResponseKeys.mediaURL] as? String,
            let objectID = json[ParseAPI.JSONResponseKeys.objectID] as? String,
            let uniqueKey = json[ParseAPI.JSONResponseKeys.uniqueKey] as? String
            else {
                print("bad data")
                return nil
        }

        return StudentInformation(studentInfoDictionary: ["firstName": firstName, "lastName": lastName, "latitude": latitude, "longitude": longitude,  "mediaURL": mediaURL, "mapString": mapString, "objectID": objectID, "uniqueKey": uniqueKey] as [String:AnyObject])
        
    }
    
    // MARK: - Shared Instance

    class func sharedInstance() -> ParseAPI {
        
        struct Singleton {
            static var sharedInstance = ParseAPI()
        }
        
        return Singleton.sharedInstance
    }
    
    
}

