//
//  TableViewController.swift
//  InstaClone
//
//  Created by Julian Nicholls on 03/09/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {

    var userNames   = [""]
    var userIDs     = [""]
    var isFollowing = ["" : false]

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        let myID  = (PFUser.currentUser()?.objectId)!

        query?.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in

            if let users = objects {
                self.userNames.removeAll()
                self.userIDs.removeAll()
                self.isFollowing.removeAll()

                for object in users {
                    if let user = object as? PFUser {
                        if user.objectId != myID {
                            self.userNames.append(user.username!)
                            self.userIDs.append(user.objectId!)

                            let query = PFQuery(className: "Relation")

                            query.whereKey("follower", equalTo: myID)
                            query.whereKey("following", equalTo: user.objectId!)

                            query.findObjectsInBackgroundWithBlock({
                                (objects, error) -> Void in

                                if let objects = objects {
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    }
                                    else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }

                                if self.isFollowing.count == self.userNames.count {
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = userNames[indexPath.row]

        let followedID = userIDs[indexPath.row]

        if isFollowing[followedID] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let followedID = userIDs[indexPath.row]

        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!

        if isFollowing[followedID] == false {   // Not following
            isFollowing[followedID] = true

            cell.accessoryType = UITableViewCellAccessoryType.Checkmark

            let relation = PFObject(className: "Relation")

            relation["following"] = userIDs[indexPath.row]
            relation["follower"]  = PFUser.currentUser()?.objectId

            relation.saveInBackground()
        }
        else {    // Following currently
            isFollowing[followedID] = false

            cell.accessoryType = UITableViewCellAccessoryType.None

            let query = PFQuery(className: "Relation")

            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("following", equalTo: userIDs[indexPath.row])

            query.findObjectsInBackgroundWithBlock({
                (objects, error) -> Void in

                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
        }
    }
}
