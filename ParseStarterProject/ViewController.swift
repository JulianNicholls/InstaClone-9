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

        }
        else {
            let alert = UIAlertController(title: "Error in Form", message: "You must enter both a username and password.", preferredStyle: .Alert)

            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (action) -> Void in

                self.dismissViewControllerAnimated(true, completion: nil)
            }))

            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func loginPressed(sender: AnyObject) {
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

