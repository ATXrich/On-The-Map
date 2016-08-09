//
//  ParseConstants.swift
//  On The Map
//
//  Created by Richard Reed on 2/15/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation

extension ParseAPI {

    struct Constants {
        
        static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let parseRESTAPIKey = "X-Parse-REST-API-Key"
        static let parseApplicationId = "X-Parse-Application-Id"
        static let parseGetURL = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let parsePostURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let parseAppJson = "application/json"
        static let parseContentType = "Content-Type"

  
    }
    
    struct JSONResponseKeys {
        

        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        static let createdAt = "createdAt"
        static let results = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"

        
    }
}
