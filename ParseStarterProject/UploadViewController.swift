//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Julian Nicholls on 03/09/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var indicator = UIActivityIndicatorView()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UITextField!

    @IBOutlet weak var uploadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        uploadButton.enabled = false
    }

    @IBAction func selectPressed(sender: AnyObject) {
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true

        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)

        self.imageView.image = image
        uploadButton.enabled = true
    }

    @IBAction func uploadPressed(sender: AnyObject) {
        let imageData   = UIImagePNGRepresentation(imageView.image!)
        let imageFile   = PFFile(name: "uploaded.png", data: imageData!)
        let photo       = PFObject(className: "Photo")

        photo["userId"]  = PFUser.currentUser()?.objectId!
        photo["caption"] = caption.text
        photo["image"]   = imageFile

        indicator = UIActivityIndicatorView(frame: self.view.frame)

        indicator.center = self.view.center
        indicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .Gray

        self.view.addSubview(indicator)

        indicator.startAnimating()

        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        photo.saveInBackgroundWithBlock {
            (success, error) -> Void in

            self.indicator.stopAnimating()

            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            if error == nil {
                self.imageView.image = UIImage(named: "blank_image.png")
                self.caption.text = ""
                self.showAlert("Upload Successful", message: "Your photo was uploaded successfully")
            }
            else {
                self.showAlert("Upload Failed", message: (error?.localizedDescription)!)
            }
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
    




    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
