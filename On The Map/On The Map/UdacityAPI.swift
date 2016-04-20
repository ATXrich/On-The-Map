//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Richard Reed on 2/15/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation

class UdacityAPI: NSObject {
    
    var username: String = ""
    var password: String = ""
    var uniqueID: String = ""
    var userFirstName: String = ""
    var userLastName: String = ""
    
    var session: NSURLSession
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Udacity API methods
    
    func loginAndCreateSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityAPI.Constants.udacitySessionURL)!)
        request.HTTPMethod = "POST"
        request.addValue(UdacityAPI.Constants.udacityAppJson, forHTTPHeaderField: UdacityAPI.Constants.udacityAccept)
        request.addValue(UdacityAPI.Constants.udacityAppJson, forHTTPHeaderField: UdacityAPI.Constants.udacityContentType)
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "The internet connection appears to be offline")
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if let errorMessage = parsedResult["error"] as? String {
                    completionHandler(success: false, errorString: errorMessage)
                } else {
                    if let registered = parsedResult["account"] as? NSDictionary {
                        self.uniqueID = registered["key"] as! String
                        self.getUserData()
                    }
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        task.resume()
    }
    

    func logoutAndDeleteSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityAPI.Constants.udacitySessionURL)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Internet connection error.")
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if parsedResult["session"] != nil {
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "Could not logout")
                }
            }
        }
        task.resume()
    }
    

    func getUserData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(UdacityAPI.Constants.udacityUserURL)\(uniqueID)")!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if let user = parsedResult["user"] as? NSDictionary {
                    self.userFirstName = user["first_name"] as! String
                    self.userLastName = user["last_name"] as! String
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Shared Instance
    

    class func sharedInstance() -> UdacityAPI {
        
        struct Singleton {
            static var sharedInstance = UdacityAPI()
        }
        
        return Singleton.sharedInstance
    }
}