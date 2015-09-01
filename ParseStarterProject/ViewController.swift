//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var signupMode = true

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!


    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func topButtonPressed(sender: AnyObject) {
        if username.text != "" && password.text != "" {
            showActivityIndicator()

            var errorMessage = "Plase try again later"

            if signupMode {
                let user = PFUser()

                user.username = username.text
                user.password = password.text

                user.signUpInBackgroundWithBlock({
                    (success, error) -> Void in

                    self.endActivity()

                    if success {
                        // Signup successful
                    }
                    else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }

                        self.showAlert("Error signing up", message: errorMessage)
                    }
                })
            }
            else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: {
                    (user, error) -> Void in

                    self.endActivity()

                    if user != nil {
                        // Logged in
                    }
                    else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }

                        self.showAlert("Error logging in", message: errorMessage)
                    }
                })
            }
        }
        else {
            showAlert("Error in Form", message: "You must enter both a username and password.")
        }
    }

    @IBAction func rightButtonPressed(sender: AnyObject) {
        if signupMode {
            leftLabel.text = "Not Registered?"
            topButton.setTitle("Log in", forState: .Normal)
            rightButton.setTitle("Sign up", forState: .Normal)

            signupMode = false
        }
        else {
            leftLabel.text = "Already Registered?"
            topButton.setTitle("Sign up", forState: .Normal)
            rightButton.setTitle("Log in", forState: .Normal)

            signupMode = true
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in

            self.dismissViewControllerAnimated(true, completion: nil)
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func showActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))

        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .Gray

        self.view.addSubview(indicator)

        indicator.startAnimating()

        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }

    func endActivity() {
        self.indicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

