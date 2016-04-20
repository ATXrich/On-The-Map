//
//  LoginViewController.swift
//  On The Map
//
//  Created by Richard Reed on 2/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViewActivityIndicator: UIActivityIndicatorView!

    
    var session: NSURLSession!
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        removeSpinner()
        loginButton.enabled = false
        loginButton.alpha = 0.5
        setTextFieldStyles()
    }
    

    
    // MARK: Login
    @IBAction func loginPressed(sender: UIButton) {
        loginToUdacity()
    }
    
    func loginToUdacity() {
        if emailTextField.text!.isEmpty {
            textFieldIsEmpty("email address")
            } else if passwordTextField.text!.isEmpty {
            textFieldIsEmpty("password")
            } else {
            self.addSpinner()
            UdacityAPI.sharedInstance().username = emailTextField.text!
            UdacityAPI.sharedInstance().password = passwordTextField.text!
            UdacityAPI.sharedInstance().loginAndCreateSession() { (success, errorString) in
                if success {
                    self.completeLogin()
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.removeSpinner()
                        let errorAlert = UIAlertController(title: errorString!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    
    private func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.removeSpinner()
            let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier("navVC") as! UINavigationController
            self.presentViewController(rootNavVC, animated: true, completion: nil)
        })
    }
    
    func addSpinner() {
        loginViewActivityIndicator.startAnimating()
        loginViewActivityIndicator.hidden = false
    }
    
    func removeSpinner() {
        loginViewActivityIndicator.stopAnimating()
        loginViewActivityIndicator.hidden = true
    }
    
    // style username and password textfields
    func setTextFieldStyles() {
        let userNamePaddingView = UIView(frame: CGRectMake(0, 0, 5, self.emailTextField.frame.height))
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, 5, self.passwordTextField.frame.height))
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.leftView = userNamePaddingView
        passwordTextField.leftView = passwordPaddingView
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    // MARK: TextField Delegate methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == emailTextField {
            loginButton.enabled = true
            loginButton.alpha = 1.0
        }
    }
    
    func textFieldIsEmpty(emptyTextField: String) {
        let emptyStringAlert = UIAlertController(title: "Please enter your \(emptyTextField)", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        emptyStringAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(emptyStringAlert, animated: true, completion: nil)
        return
    }
    
    
}