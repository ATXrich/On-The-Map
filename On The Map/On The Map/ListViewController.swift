//
//  ListViewController.swift
//  On The Map
//
//  Created by Richard Reed on 2/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var students: [StudentInformation] = ParseAPI.sharedInstance().studentLocations
    @IBOutlet weak var studentsTableView: UITableView!
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableViewActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        addSpinner()
        getStudentLocations()
    }
    
    
    func getStudentLocations() {
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
                self.students = studentResult
                self.studentsTableView.reloadData()
            }
        }
    }
    

    func addSpinner() {
        tableViewActivityIndicator.startAnimating()
        tableViewActivityIndicator.hidden = false
    }
    
    func removeSpinner() {
        tableViewActivityIndicator.stopAnimating()
        tableViewActivityIndicator.hidden = true
    }
    
    func refreshView(){
        getStudentLocations()
    }
    
    // MARK: -- TableView Delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath)
        let firstName = students[indexPath.row].firstName as String
        let lastName = students[indexPath.row].lastName as String
        let studentUrl = students[indexPath.row].mediaURL as String
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.detailTextLabel?.text = ("\(studentUrl)")
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
    

    
}
