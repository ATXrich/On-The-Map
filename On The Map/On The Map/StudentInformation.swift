//
//  StudentInformation.swift
//  On The Map
//
//  Created by Richard Reed on 2/16/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation


struct StudentInformation {
    
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: String
    
    init(studentInfoDictionary: [String: AnyObject]) {
        self.firstName = studentInfoDictionary["firstName"] as! String!
        self.lastName = studentInfoDictionary["lastName"] as! String!
        self.longitude = studentInfoDictionary["longitude"] as! Float
        self.latitude = studentInfoDictionary["latitude"] as! Float
        self.mediaURL = studentInfoDictionary["mediaURL"] as! String!
        self.mapString = studentInfoDictionary["mapString"] as! String!
        self.objectID = studentInfoDictionary["objectID"] as! String!
        self.uniqueKey = studentInfoDictionary["uniqueKey"] as! String!
    }
    

    
}