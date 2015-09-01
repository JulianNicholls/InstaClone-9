//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signupPressed(sender: AnyObject) {
        if username.text != "" && password.text != "" {
            showActivityIndicator()

            let user = PFUser()

            user.username = username.text
            user.password = password.text

            var errorMessage = "Plase try again later"
            
            user.signUpInBackgroundWithBlock({
                (success, error) -> Void in

                self.indicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()

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
            showAlert("Error in Form", message: "You must enter both a username and password.")
        }
    }

    @IBAction func loginPressed(sender: AnyObject) {
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

