//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Richard Reed on 3/16/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    
    
    
    @IBAction func logout(sender: AnyObject) {
        UdacityAPI.sharedInstance().logoutAndDeleteSession() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let errorAlert = UIAlertController(title: errorString!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                })
            }
        }
        
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        let postLocVC = self.storyboard!.instantiateViewControllerWithIdentifier("postLocVC") as! PostLocationViewController
        presentViewController(postLocVC, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshView(sender: AnyObject) {
        if self.selectedIndex == 0 {
            let mapVC = self.viewControllers![0] as! MapViewController
            mapVC.refreshView()
        } else if self.selectedIndex == 1 {
            let tableVC = self.viewControllers![1] as! ListViewController
            tableVC.refreshView()
        }
        
        
    }
    
    
}
