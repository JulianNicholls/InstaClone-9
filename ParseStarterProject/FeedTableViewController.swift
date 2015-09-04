//
//  FeedTableViewController.swift
//  InstaClone
//
//  Created by Julian Nicholls on 04/09/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var captions    = [""]
    var imageFiles  = [PFFile()]
    var users       = ["": ""]
    var userNames   = [""]

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsersFromParse()

        let followingQuery = PFQuery(className: "Relation")

        followingQuery.whereKey("follower", equalTo: (PFUser.currentUser()!.objectId)!)

        followingQuery.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in

            if let relations = objects {
                self.captions.removeAll()
                self.imageFiles.removeAll()
                self.userNames.removeAll()

                for relation in relations {
                    let followed    = relation["following"] as! String
                    let imageQuery  = PFQuery(className: "Photo")

                    imageQuery.whereKey("userId", equalTo: followed)

                    imageQuery.findObjectsInBackgroundWithBlock({
                        (objects, error) -> Void in

                        if let photos = objects {
                            for photo in photos {
                                self.captions.append(photo["caption"] as! String)
                                self.imageFiles.append(photo["image"] as! PFFile)
                                self.userNames.append(self.users[followed]!)
                            }

                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }


    func loadUsersFromParse() {
        let query = PFUser.query()

        query?.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in

            if let users = objects {
                self.users.removeAll()

                for object in users {
                    if let user = object as? PFUser {
                         self.users[user.objectId!] = user.username!
                    }
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let imageCell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! TableViewCell

        print("Row: \(indexPath.row)")
        print("Images: \(imageFiles.count)")
        print(imageFiles[indexPath.row])

        imageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (data: NSData?, error: NSError?) -> Void in

            print("In callback")

            if error == nil {
                if let downloadedImage = UIImage(data: data!) {
                    imageCell.uploaded.image = downloadedImage
                }
            }
            else {
                print(error?.localizedDescription)
            }
        }

        imageCell.caption.text      = captions[indexPath.row]
        imageCell.username.text     = userNames[indexPath.row]

        return imageCell
    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
