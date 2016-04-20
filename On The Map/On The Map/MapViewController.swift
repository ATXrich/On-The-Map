//
//  MapViewController.swift
//  On The Map
//
//  Created by Richard Reed on 2/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var students: [StudentInformation] = ParseAPI.sharedInstance().studentLocations
    @IBOutlet weak var mapViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapViewActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        addSpinner()
        getStudentLocations()

    }
    
    func getStudentLocations() {
        mapView.removeAnnotations(mapView.annotations)
        ParseAPI.sharedInstance().getStudentLocation {
            (let students) in
            guard let studentResult = students else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.removeSpinner()
                    let errorAlert = UIAlertController(title: "Error", message: "There was a problem retrieving student locations.", preferredStyle: UIAlertControllerStyle.Alert)
                    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.removeSpinner()
                self.showStudentMapLocations(studentResult)
                
            }
        }
    }
    
    func addSpinner() {
        mapViewActivityIndicator.startAnimating()
        mapViewActivityIndicator.hidden = false
    }
    
    func removeSpinner() {
        mapViewActivityIndicator.stopAnimating()
        mapViewActivityIndicator.hidden = true
    }
    
    
    func refreshView() {
        getStudentLocations()
    }
    
    // MARK: MapView methods
    
    private func showStudentMapLocations(students: [StudentInformation]) {
        
        var annotations = [MKPointAnnotation]()

        for student in students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }

    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
  
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }

    
}

