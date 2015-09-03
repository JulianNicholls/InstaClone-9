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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @IBAction func uploadPressed(sender: AnyObject) {
        let imageData   = UIImagePNGRepresentation(self.imageView.image!)
        let imageFile   = PFFile(name: "uploaded.png", data: imageData!)
        let photo       = PFObject(className: "Photo")

        photo["userId"]  = PFUser.currentUser()?.objectId!
        photo["caption"] = caption.text
        photo["image"]   = imageFile

        photo.saveInBackground()
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
